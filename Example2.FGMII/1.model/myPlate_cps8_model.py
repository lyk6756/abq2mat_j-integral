'''
-------------------------------------------------------------------------------
 Mixed-mode crack in a FGM plate modeled using
 quadratic plane-stress quadrilateral elements (CPS8).
-------------------------------------------------------------------------------
'''

# === Modules ===

from abaqus import *
from abaqusConstants import *
from caeModules import *

import math

#------------------------------------------------------------------------------

# === Parameters ===

# Specimen geometry (mm)
WW = 70                                   # width of the plate
HH = 90                                   # height of the plate
hh = 45                                   # height of the crack tip
phi = math.pi / 3                         # angle of the crack plane
aa = 26                                   # height of the crack-tip
DD = 43 - aa * math.sin(phi)              # Offset of the plate to fit material properties

# Material
xnu = 0.45                                # Poisson's ratio
NSDV = 1                                  # Number of SDV

# Mesh control
size_end = 2.0
size_tip = 1.0
num_rings = 4
elms_in_ring = 24

# BC
uy = 0.95

#------------------------------------------------------------------------------

# === Create model ===

Mdb()
mymodelName = 'myFGMIIplate'
myModel = mdb.Model(name=mymodelName)
del mdb.models['Model-1']

# Create a new viewport in which to display the model
# and the results of the analysis.

viewportName = session.Viewport(name=mymodelName)
viewportName.makeCurrent()
viewportName.maximize()

#------------------------------------------------------------------------------

# === Create sketch ===

plateSketch = myModel.ConstrainedSketch(name='plateProfile', sheetSize=2.0)

plateSketch.rectangle(point1=(0.0, 0.0), point2=(WW, HH))

# === Create part ===

platePartName = 'plate'
platePart = myModel.Part(dimensionality=TWO_D_PLANAR, name=platePartName,
    type=DEFORMABLE_BODY)
platePart.BaseShell(sketch=plateSketch)

#------------------------------------------------------------------------------

# === Create part partition ===

# Crack

crackSketch = myModel.ConstrainedSketch(name='plateProfile', sheetSize=2.0)

crackSketch.Line(point1=(0.0, hh-aa*math.cos(phi)),
    point2=(aa*math.sin(phi), hh))

pickedFaces = platePart.faces
platePart.PartitionFaceBySketch(faces=pickedFaces, sketch=crackSketch)

# Crack-tip Refinement

refineSketch = myModel.ConstrainedSketch(name='refineProfile', sheetSize=2.0)

refineSketch.CircleByCenterPerimeter(center=(aa*math.sin(phi), hh), point1=(
    (aa-size_tip)*math.sin(phi), hh-size_tip*math.cos(phi)))

pickedFaces = platePart.faces
platePart.PartitionFaceBySketch(faces=pickedFaces, sketch=refineSketch)

#------------------------------------------------------------------------------

# === Create geometry sets ===

pickedFaces = platePart.faces
platePart.Set(faces=pickedFaces, name='All')

# === End part ===

#------------------------------------------------------------------------------

# === Define material and section properties ===

plateMaterialName = 'GradedLinearElastic'
umatMatl = myModel.Material(name=plateMaterialName)
umatMatl.UserDefinedField()
umatMatl.Elastic(dependencies=NSDV, table=((0.1, xnu, 0.1),
    (1000000.0, xnu, 1000000.0)))

plateSectionName = 'Solid'
myModel.HomogeneousSolidSection(name=plateSectionName,
    material=plateMaterialName)

#------------------------------------------------------------------------------

# === Assign section ===

region = platePart.sets['All']
platePart.SectionAssignment(region=region, sectionName=plateSectionName)

#------------------------------------------------------------------------------

# === Assemble ===

myAssembly = myModel.rootAssembly
myAssembly.DatumCsysByDefault(CARTESIAN)

myInstanceName = 'plate-1'
myInstance = myAssembly.Instance(name=myInstanceName, part=platePart,
    dependent=OFF)

#------------------------------------------------------------------------------

# === Create assembly sets ===

pickedFaces = myInstance.faces[:]
myAssembly.Set(faces=pickedFaces, name='All')

pickedEdges = myInstance.edges.findAt( ((WW/2.0, 0.0, 0.0),) )
myAssembly.Set(edges=pickedEdges, name='Bottom')

pickedEdges = myInstance.edges.findAt( ((WW/2.0, HH, 0.0),) )
myAssembly.Set(edges=pickedEdges, name='Top')

pickedVerts = myInstance.vertices.findAt( ((WW, 0.0, 0.0),) )
myAssembly.Set(vertices=pickedVerts, name='RightBottom')

pickedVerts = myInstance.vertices.findAt( ((aa*math.sin(phi), hh, 0.0),) )
myAssembly.Set(vertices=pickedVerts, name='crackFront')

pickedEdges = myInstance.edges.findAt( ((aa*math.sin(phi), hh, 0.0),) )
myAssembly.Set(edges=pickedEdges, name='crackPlaneRefined')

pickedEdges = myInstance.edges.findAt(
    (((aa-size_tip)/2*math.sin(phi), hh-(aa+size_tip)/2*math.cos(phi), 0.0),))
myAssembly.Set(edges=pickedEdges, name='crackPlaneCoarse')

pickedEdges = myInstance.edges.findAt( ((aa*math.sin(phi), hh, 0.0),),
    (((aa-size_tip)/2*math.sin(phi), hh-(aa+size_tip)/2*math.cos(phi), 0.0),))
myAssembly.Set(edges=pickedEdges, name='seamCrackEdge')

pickedEdges = myInstance.edges.findAt( ((aa*math.sin(phi)+size_tip, hh, 0.0),))
myAssembly.Set(edges=pickedEdges, name='crackRefined')

#------------------------------------------------------------------------------

# === Create step ===

myStepName = 'ApplyLoad'
myModel.StaticStep(name=myStepName, previous='Initial')

myModel.fieldOutputRequests['F-Output-1'].setValues(
    variables=('U', 'RF', 'S', 'E'))

del myModel.historyOutputRequests['H-Output-1']

#------------------------------------------------------------------------------

# === Define crack ===

# Assign seam crack
pickedRegions = myAssembly.sets['seamCrackEdge']
myAssembly.engineeringFeatures.assignSeam(regions=pickedRegions)

# Assign seam crack properties
myCrackName = 'Crack-1'
crackFront = myAssembly.sets['crackFront']
crackTip = myAssembly.sets['crackFront']
myAssembly.engineeringFeatures.ContourIntegral(name=myCrackName,
    symmetric=OFF, crackFront=crackFront, crackTip=crackTip,
    extensionDirectionMethod=Q_VECTORS, qVectors=(((0.0, 0.0, 0.0),
    (math.sin(phi), math.cos(phi), 0.0)), ),
    midNodePosition=0.25, collapsedElementAtTip=SINGLE_NODE)

#------------------------------------------------------------------------------

# Request history output for the crack

myModel.HistoryOutputRequest(name='J-int', createStepName=myStepName,
    contourIntegral=myCrackName, sectionPoints=DEFAULT,
    rebar=EXCLUDE, numberOfContours=5, contourType=J_INTEGRAL)

myModel.HistoryOutputRequest(name='SIF', createStepName=myStepName,
    contourIntegral=myCrackName, sectionPoints=DEFAULT,
    rebar=EXCLUDE, numberOfContours=5, contourType=K_FACTORS)

#------------------------------------------------------------------------------

# === Apply boundary conditions ===

# Fixed BC

region = myAssembly.sets['Bottom']
myModel.DisplacementBC(name='BTM', createStepName=myStepName,
    region=region, u1=UNSET, u2=0.0, ur3=UNSET, amplitude=UNSET, fixed=OFF,
    distributionType=UNIFORM, localCsys=None)

region = myAssembly.sets['RightBottom']
myModel.DisplacementBC(name='Right', createStepName=myStepName,
    region=region, u1=0.0, u2=UNSET, ur3=UNSET, amplitude=UNSET, fixed=OFF,
    distributionType=UNIFORM, localCsys=None)

# Load

region = myModel.rootAssembly.sets['Top']
myModel.DisplacementBC(name='load', createStepName=myStepName,
    region=region, u1=UNSET, u2=uy, ur3=UNSET, amplitude=UNSET, fixed=OFF,
    distributionType=UNIFORM, localCsys=None)

#------------------------------------------------------------------------------

# === Assign mesh controls and mesh instance ===

# Element type
elemType1 = mesh.ElemType(elemCode=CPS8, elemLibrary=STANDARD)
elemType2 = mesh.ElemType(elemCode=CPS6M, elemLibrary=STANDARD)

pickedRegions = myInstance.sets['All']
myAssembly.setElementType(regions=pickedRegions,
    elemTypes=(elemType1, elemType2))

# Mesh technique
pickedRegions = myInstance.sets['All'].faces
myAssembly.setMeshControls(regions=pickedRegions, elemShape=QUAD)

pickedRegions = myInstance.faces.findAt( ((aa*math.sin(phi), hh, 0.0),) )
myAssembly.setMeshControls(regions=pickedRegions, elemShape=QUAD_DOMINATED,
    technique=SWEEP)

# Seed mesh

myAssembly.seedPartInstance(regions=(myInstance, ), size=size_end,
    deviationFactor=0.1, minSizeFactor=0.1)

pickedEdges = myAssembly.sets['crackPlaneRefined'].edges
myAssembly.seedEdgeByNumber(edges=pickedEdges, number=num_rings)

pickedEdges = myAssembly.sets['crackRefined'].edges
myAssembly.seedEdgeByNumber(edges=pickedEdges, number=elms_in_ring)

pickedEdges = myAssembly.sets['crackPlaneCoarse'].edges
myAssembly.seedEdgeByBias(biasMethod=SINGLE, end2Edges=pickedEdges,
    minSize=size_tip/num_rings, maxSize=size_end, constraint=FINER)

myModel.rootAssembly.generateMesh(regions=(myInstance, ))

#------------------------------------------------------------------------------

# Offset for FGM material properties

myAssembly.translate(instanceList=(myInstanceName, ), vector=(DD, 0.0, 0.0))

# === End assembly ===

#------------------------------------------------------------------------------

# === Create Job ===

myJobName = 'Job-1'
myJob = mdb.Job(name=myJobName, model=mymodelName)
myJob.writeInput(consistencyChecking=OFF)
mdb.saveAs(pathName=mymodelName)

#------------------------------------------------------------------------------
