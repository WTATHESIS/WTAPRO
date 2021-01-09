import numpy as np
import time
from addvirtualnode_neighborsearch_alg import addvirtualnode_neighborsearch_alg
from neighborsearch_alg import neighborsearch_alg


def vector_to_fitness(weaponnum, targetnum, comkillpro, vector):
    decisionmatrix = np.zeros((weaponnum, targetnum))
    for i in range(weaponnum):
        decisionmatrix[i, vector[i]] = 1
    targetfitness = np.zeros((1, targetnum))
    for i in range(targetnum):
        targetfitness[0][i] = targetvalue[0][i]
        for j in range(weaponnum):
            targetfitness[0][i] = targetfitness[0][i] * comkillpro[j, i] ** decisionmatrix[j, i]
    solutionfitness = targetfitness.sum()
    return solutionfitness, targetfitness


weaponnum = 20
targetnum = 12

# targetvalue = np.random.rand(1,targetnum)
# comkillpro = np.random.rand(weaponnum,targetnum)
#
# np.save('targetvalue.npy',targetvalue)
# np.save('comkillpro.npy',comkillpro)

targetvalue = np.load('targetvalue.npy')
comkillpro = np.load('comkillpro.npy')
# print(targetvalue,comkillpro)

# testsolutions = np.random.randint(targetnum,size=(100,weaponnum))
# np.save('testsolutions.npy',testsolutions)
testsolutions = np.load('testsolutions.npy')
pathlen = 3
virtualnodemax = 1
iterationmax = 4

rawfitness = np.zeros((1, 100))
virtualsolutionfitness = np.zeros((1, 100))
classicsolutionfitness = np.zeros((1, 100))
virtualtime = np.zeros((1, 100))
classictime = np.zeros((1, 100))
for i in range(100):

    rawfitness[0, i], rawtargetfitness = vector_to_fitness(weaponnum, targetnum, comkillpro, testsolutions[i, :])

    virtualstart = time.perf_counter()
    virtualtargetset, virtualsolutionfitness[0,i] = addvirtualnode_neighborsearch_alg(weaponnum, targetnum, targetvalue,
                                                                                  comkillpro, testsolutions[i, :],
                                                                                  pathlen, virtualnodemax, iterationmax)
    virtualend = time.perf_counter()
    virtualtime[0, i] = virtualend - virtualstart

    start = time.perf_counter()
    classictargetset, classicsolutionfitness[0,i] = neighborsearch_alg(weaponnum, targetnum, targetvalue, comkillpro, testsolutions[i, :],
                                                    pathlen, iterationmax)
    end = time.perf_counter()
    classictime[0, i] = end - start

end
np.save('rawfitness.npy',rawfitness)
np.save('virtualsolutionfitness.npy',virtualsolutionfitness)
np.save('classicsolutionfitness.npy',classicsolutionfitness)
np.save('virtualtime.npy', virtualtime)
np.save('classictime.npy', classictime)
