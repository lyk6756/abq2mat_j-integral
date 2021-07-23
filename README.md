# Abaqus to Matlab J-integral

该项目将Abaqus输入和结果文件读取到Matlab中，然后针对特定的二维算例计算J积分。两个算例分别计算了均匀板（HOMI）和功能梯度材料板（FGMII）的混合裂纹。算例的详细信息可参考如下文献，亦可在[`papers`](/papers/)文件夹中找到。

## 参考文献

* [Abanto-Bueno, J., Lambros, J. An Experimental Study of Mixed Mode Crack Initiation and Growth in Functionally Graded Materials. Exp Mech 46, 179–196 (2006).](https://doi.org/10.1007/s11340-006-6416-6)
* [Alpay Oral, Jorge L. Abanto‐Bueno, John Lambros, and Gunay Anlas. Crack Initiation Angles in Functionally Graded Materials under Mixed Mode Loading. AIP Conference Proceedings 973, 248-253 (2008).](https://doi.org/10.1063/1.2896785)
* [Oral, A., Lambros, J., and Anlas, G. Crack Initiation in Functionally Graded Materials Under Mixed Mode Loading: Experiments and Simulations. ASME. J. Appl. Mech. September 2008; 75(5): 051110.](https://doi.org/10.1115/1.2936238)
* [Martínez-Pañeda, E., Gallego, R. Numerical analysis of quasi-static fracture in functionally graded materials. Int J Mech Mater Des 11, 405–424 (2015).](https://doi.org/10.1007/s10999-014-9265-y)

## 步骤一：在Abaqus中建立模型

在文件夹`1.model`中，运行Abaqus脚本`myPlate_cps8_model.py`来建立有限元模型，并生成Abaqus输入文件（`.inp`）。

在提交作业前，修改输入文件的历史输出部分指令，加入如下代码来生成包含位移等信息的结果文件（`.fil`）

```
*FILE FORMAT, ASCII
*NODE FILE
 U
```

如果计算的是非均匀材料板（`Example2.FGMII`），脚本会创建用户自定义材料，在提交作业时需要链接USDFLD用户子程序文件（`myUSDFLD_FGMII.for`）。此外，为了使得Abaqus能够计算非均匀材料的裂尖信息，需要在输入文件的材料定义部分添加如下代码：

```
*INITIAL CONDITIONS, TYPE=FIELD, VARIABLE=1
All, 100
```

并在分析步中添加如下代码：

```
*FIELD, USER
All,
```

## 步骤二：Abaqus至Matlab

将文件夹`1.model`中生成的输入文件（`.inp`）和结果文件（`.fil`）拷贝至文件夹`2.abq2mat`中。在文件夹`2.abq2mat`中，运行Matlab脚本`main_getdata.m`来获取模型信息。得到的模型信息将储存为Matlab数据文件（`.mat`）。

**注意**脚本`main_getdata.m`中采用了小工具[abaqusMesh2Matlab][abaqusMesh2Matlab]来读取Abaqus输入文件（`.inp`），采用了小工具[Abaqus2Matlab V2.0][Abaqus2Matlab][^1]来读取Abaqus结果文件（`.fil`）。运行`main_getdata.m`前应首先安装这两个小工具。相关安装文件可在[`gadgets`](/gadgets/)文件夹中找到。

## 步骤三：在Matlab中计算*J*积分

将文件夹`2.abq2mat`中生成的Matlab数据文件（`.mat`）拷贝至文件夹`3.J-int`中。在文件夹`3.J-int`中，运行Matlab脚本`main.m`来计算*J*积分及应力强度因子。结果将会输出在屏幕上，并写入文件中（`ResultsFromMat.csv`）。

积分程序中的部分代码来自于[jfchessa/femlab - GitHub](https://github.com/jfchessa/femlab)。

---

# Abaqus to Matlab J-integral

This repository reads Abaqus input and result files to Matlab, then calculate the J-integral for specific 2D problems. Two examples calculate the mixed cracks of a homogeneous plate (HOMI) and functionally graded material plate (FGMII), respectively. The detailed information of the examples can be found in the following papers, which can also be found in the folder [`papers`](/papers/).

## References

* [Abanto-Bueno, J., Lambros, J. An Experimental Study of Mixed Mode Crack Initiation and Growth in Functionally Graded Materials. Exp Mech 46, 179–196 (2006).](https://doi.org/10.1007/s11340-006-6416-6)
* [Alpay Oral, Jorge L. Abanto‐Bueno, John Lambros, and Gunay Anlas. Crack Initiation Angles in Functionally Graded Materials under Mixed Mode Loading. AIP Conference Proceedings 973, 248-253 (2008).](https://doi.org/10.1063/1.2896785)
* [Oral, A., Lambros, J., and Anlas, G. Crack Initiation in Functionally Graded Materials Under Mixed Mode Loading: Experiments and Simulations. ASME. J. Appl. Mech. September 2008; 75(5): 051110.](https://doi.org/10.1115/1.2936238)
* [Martínez-Pañeda, E., Gallego, R. Numerical analysis of quasi-static fracture in functionally graded materials. Int J Mech Mater Des 11, 405–424 (2015).](https://doi.org/10.1007/s10999-014-9265-y)

## Step 1: Modelling in Abaqus

In the folder `1.model`, run script `myPlate_cps8_model.py` in Abaqus/CAE to set up the FEM model and generate input job file (`.inp`).

Before submitting the job, modify the history output commands of the input file: add the following commands to generate a result file (`.fil`) containing displacement and other information:

```
*FILE FORMAT, ASCII
*NODE FILE
 U
```

If a non-homogenerous plate is modeled (`Example2.FGMII`), the script will creat user-defined materials. And user subroutine USDFLD (`myUSDFLD_FGMII.for`) should be linked when submitting the job. To compute the *J*-integral and SIFs for non-homogenerous materials in Abaqus, following keywords should be added to MATERIALS module of the input file:

```
*INITIAL CONDITIONS, TYPE=FIELD, VARIABLE=1
All, 100
```

Then, add following keywords in STEP module:

```
*FIELD, USER
All,
```

## Step 2: Abaqus to Matlab

Copy the input file (`.inp`) and result file (`.fil`) generated in the folder `1.model` to the folder `2.abq2mat`. In the folder `2.abq2mat`, run script `main_getdata.m` in Matlab to get the model information. The obtained model information will be stored as a Matlab data file (`.mat`).

**Note** that inscript `main_getdata.m`, gadget [abaqusMesh2Matlab][abaqusMesh2Matlab] is used to read the Abaqus input file (`.inp`), and [Abaqus2Matlab V2.0][Abaqus2Matlab][^1] to Abaqus result file (`.fil`). These two gadgets should be installed before running `main_getdata.m`. The relevant files can be found in the folder [`gadgets`](/gadgets/).

## Step 3: *J*-integral in Matlab

Copy the Matlab data file (`.mat`) generated in the folder `2.abq2mat` to the folder `3.J-int`. In the folder `3.J-int`, run the Matlab script `main.m` to calculate the *J*-integrals and stress intensity factors. The results will be output on the screen, and write into the file (`ResultsFromMat.csv`).

Part of the code in this program comes from [jfchessa/femlab-GitHub](https://github.com/jfchessa/femlab).

---

[^1]: [George Papazafeiropoulos, Miguel Muñiz-Calvente, Emilio Martínez-Pañeda. Abaqus2Matlab: A suitable tool for finite element post-processing. Advances in Engineering Software 105, 9-16 (2017)](https://doi.org/10.1016/j.advengsoft.2017.01.006) / [GeorgePapazafeiropoulos/Abaqus2Matlab - GitHub](https://github.com/GeorgePapazafeiropoulos/Abaqus2Matlab).

[Abaqus2Matlab]: http://www.abaqus2matlab.com/
[abaqusMesh2Matlab]: https://www.mathworks.com/matlabcentral/fileexchange/67437-abaqusmesh2matlab
