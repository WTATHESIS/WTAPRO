def addvirtualnode_neighborsearch_alg(weaponnum, targetnum, targetvalue, comkillpro, solution, pathlen, virtualnodemax, iterationmax):

    import numpy as np
    from copy import deepcopy

    def vector_to_set(weaponnum, targetnum, solution):
        targetset = [[] for i in range(0, targetnum)]
        targetsetlen = np.zeros(targetnum, int)
        for i in range(0, weaponnum):
            targetindex = solution[i]
            targetset[targetindex].append(i)
        for i in range(targetnum):
            targetsetlen[i] = len(targetset[i])
        return targetset, targetsetlen

    def solution_fitness(weaponnum, targetnum, targetset, targetsetlen, targetvalue, comkillpro):

        decisionmatrix = np.zeros((weaponnum, targetnum))
        for i in range(targetnum):
            for j in range(targetsetlen[i]):
                decisionmatrix[targetset[i][j], i] = 1

        targetfitness = np.zeros((1, targetnum))
        for i in range(targetnum):
            targetfitness[0][i] = targetvalue[0][i]
            for j in range(weaponnum):
                targetfitness[0][i] = targetfitness[0][i] * comkillpro[j, i] ** decisionmatrix[j, i]

        solutionfitness = targetfitness.sum()

        return solutionfitness, targetfitness

    def pathcycliccost(pathweapon, pathtarget, len, targetfitness, comkillpro):
        pathcost = 0
        for i in range(len):
            startweapon = pathweapon[i]
            endweapon = pathweapon[i + 1]
            endtarget = pathtarget[i + 1]
            pathcost = pathcost + targetfitness[0, endtarget] * (
                    comkillpro[startweapon, endtarget] / comkillpro[endweapon, endtarget] - 1)
        cycliccost = pathcost + targetfitness[0, pathtarget[0]] * (
                comkillpro[pathweapon[-1], pathtarget[0]] / comkillpro[pathweapon[0], pathtarget[0]] - 1)
        return pathcost, cycliccost

    def addvirtualnodeneighborsearch(weaponnum, targetnum, targetset, targetsetlen, targetfitness, comkillpro, pathlen,
                                     virtualnodemax):

        comkillpro = np.vstack((comkillpro, np.ones((1, targetnum))))
        optweaponcyclic = []
        opttargetcyclic = []
        optcycliccost = 0

        negweaponpathset = []
        negtargetpathset = []
        negpathnum = 0
        for i in range(targetnum):
            for m in range(targetsetlen[i]):
                startweapon = targetset[i][m]
                for j in range(targetnum):
                    if j != i:
                        for n in range(targetsetlen[j]):
                            endweapon = targetset[j][n]
                            weaponpath = np.array([startweapon, endweapon])
                            targetpath = np.array([i, j])
                            pathcost, cycliccost = pathcycliccost(weaponpath, targetpath, 1, targetfitness, comkillpro)
                            if pathcost < 0:
                                negweaponpathset.append(weaponpath)
                                negtargetpathset.append(targetpath)
                                negpathnum = negpathnum + 1
                                if cycliccost < optcycliccost:
                                    optweaponcyclic = weaponpath
                                    opttargetcyclic = targetpath
                                    optcycliccost = cycliccost

        # print("初始解：%s 数量：%s 最优解：%s 收益：%s" % (targetset, negpathnum, optweaponcyclic, optcycliccost))
        # print("武器：%s" %negweaponpathset)
        # print("目标：%s" %negtargetpathset)

        for pathindex in range(2, pathlen + 1):
            nextnegweaponpathset = []
            nextnegtargetpathset = []
            nextnegpathnum = 0
            for i in range(negpathnum):
                weaponpath = negweaponpathset[i]
                targetpath = negtargetpathset[i]
                availabletargetset = np.arange(targetnum)
                availabletargetset = np.delete(availabletargetset, targetpath, 0)
                for j in range(np.size(availabletargetset)):
                    availableweaponset = targetset[availabletargetset[j]]
                    modavailableweaponset = availableweaponset[:]
                    if virtualnodemax != 0:
                        if weaponpath[-1] == weaponnum or str(list(weaponpath)).count(str(weaponnum)) >= virtualnodemax:
                            modavailableweaponset.remove(weaponnum)
                    for k in range(np.size(modavailableweaponset)):
                        nextweaponpath = np.append(weaponpath, modavailableweaponset[k])
                        nexttargetpath = np.append(targetpath, availabletargetset[j])
                        nextpathcost, nextcycliccost = pathcycliccost(nextweaponpath, nexttargetpath, pathindex,
                                                                      targetfitness,
                                                                      comkillpro)
                        if nextpathcost < 0:
                            nextnegweaponpathset.append(nextweaponpath)
                            nextnegtargetpathset.append(nexttargetpath)
                            nextnegpathnum = nextnegpathnum + 1
                            if nextcycliccost < optcycliccost:
                                optweaponcyclic = nextweaponpath
                                opttargetcyclic = nexttargetpath
                                optcycliccost = nextcycliccost
            # print("数量：%s 收益：%s" % (nextnegpathnum, optcycliccost))
            # print("武器：%s" % (nextnegweaponpathset))
            # print("目标：%s" % (nextnegtargetpathset))
            negweaponpathset = nextnegweaponpathset[:]
            negtargetpathset = nextnegtargetpathset[:]
            negpathnum = nextnegpathnum

        return optweaponcyclic, opttargetcyclic, optcycliccost

    def solutionupdate(weaponnum, targetset, targetsetlen, optweaponcyclic, opttargetcyclic):
        newtargetset = deepcopy(targetset)
        newtargetsetlen = deepcopy(targetsetlen)
        for i in range(len(opttargetcyclic)):
            if optweaponcyclic[i - 1] == weaponnum:
                continue
            else:
                preweaponindex = targetset[opttargetcyclic[i - 1]].index(optweaponcyclic[i - 1])
                newtargetset[opttargetcyclic[i]].append(targetset[opttargetcyclic[i - 1]][preweaponindex])
                newtargetsetlen[opttargetcyclic[i]] = newtargetsetlen[opttargetcyclic[i]] + 1
                newtargetset[opttargetcyclic[i - 1]].remove(targetset[opttargetcyclic[i - 1]][preweaponindex])
                newtargetsetlen[opttargetcyclic[i - 1]] = newtargetsetlen[opttargetcyclic[i - 1]] - 1

        return newtargetset, newtargetsetlen

    targetset, targetsetlen = vector_to_set(weaponnum, targetnum, solution)
    print(targetset)
    print(targetsetlen)

    for iteration in range(iterationmax):

        solutionfitness, targetfitness = solution_fitness(weaponnum, targetnum, targetset, targetsetlen, targetvalue,
                                                          comkillpro)
        if virtualnodemax != 0:
            for i in range(0, targetnum):
                targetset[i].append(weaponnum)
                targetsetlen[i] = len(targetset[i])

        optweaponcyclic, opttargetcyclic, optcycliccost = addvirtualnodeneighborsearch(weaponnum, targetnum, targetset,
                                                                                       targetsetlen, targetfitness,
                                                                                       comkillpro, pathlen, virtualnodemax)
        print(optweaponcyclic, opttargetcyclic, optcycliccost)

        if virtualnodemax != 0:
            for i in range(targetnum):
                targetset[i].remove(weaponnum)
                targetsetlen[i] = targetsetlen[i] - 1

        newtargetset, newtargetsetlen = solutionupdate(weaponnum, targetset, targetsetlen, optweaponcyclic, opttargetcyclic)
        print(newtargetset, newtargetsetlen)

        newsolutionfitness, newtargetfitness = solution_fitness(weaponnum, targetnum, newtargetset, newtargetsetlen,
                                                                targetvalue, comkillpro)

        targetset = newtargetset
        targetsetlen = newtargetsetlen

    print(solutionfitness + optcycliccost, newsolutionfitness)

    return newtargetset, newsolutionfitness
