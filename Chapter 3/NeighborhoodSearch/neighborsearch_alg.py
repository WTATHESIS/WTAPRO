def neighborsearch_alg(weaponnum, targetnum, targetvalue, comkillpro, solution, pathlen, iterationmax):

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
        for i in range(0, len):
            startweapon = pathweapon[i]
            endweapon = pathweapon[i + 1]
            endtarget = pathtarget[i + 1]
            pathcost = pathcost + targetfitness[0, endtarget] * (
                    comkillpro[startweapon, endtarget] / comkillpro[endweapon, endtarget] - 1)
        cycliccost = pathcost + targetfitness[0, pathtarget[0]] * (
                comkillpro[pathweapon[-1], pathtarget[0]] / comkillpro[pathweapon[0], pathtarget[0]] - 1)
        return pathcost, cycliccost

    def neighborsearch(targetnum, targetset, targetsetlen, targetfitness, comkillpro, pathlen):

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
        # print("武器：%s" % negweaponpathset)
        # print("目标：%s" % negtargetpathset)

        for pathindex in range(2, pathlen + 1):
            nextnegweaponpathset = []
            nextnegtargetpathset = []
            nextnegpathnum = 0
            for i in range(negpathnum):
                availabletargetset = np.arange(targetnum)
                availabletargetset = np.delete(availabletargetset, negtargetpathset[i], 0)
                for j in range(np.size(availabletargetset)):
                    availableweaponset = targetset[availabletargetset[j]]
                    for k in range(np.size(availableweaponset)):
                        nextweaponpath = negweaponpathset[i]
                        nexttargetpath = negtargetpathset[i]
                        nextweaponpath = np.append(nextweaponpath, availableweaponset[k])
                        nexttargetpath = np.append(nexttargetpath, availabletargetset[j])
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
            # print("武器：%s" % nextnegweaponpathset)
            # print("目标：%s" % nextnegtargetpathset)
            negweaponpathset = nextnegweaponpathset
            negtargetpathset = nextnegtargetpathset
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

        optweaponcyclic, opttargetcyclic, optcycliccost = neighborsearch(targetnum, targetset,
                                                                                       targetsetlen,
                                                                                       targetfitness, comkillpro,
                                                                                       pathlen)
        print(optweaponcyclic, opttargetcyclic, optcycliccost)

        newtargetset, newtargetsetlen = solutionupdate(weaponnum, targetset, targetsetlen, optweaponcyclic,
                                                       opttargetcyclic)
        print(newtargetset, newtargetsetlen)

        newsolutionfitness, newtargetfitness = solution_fitness(weaponnum, targetnum, newtargetset, newtargetsetlen,
                                                                targetvalue, comkillpro)

        targetset = newtargetset
        targetsetlen = newtargetsetlen

    print(solutionfitness + optcycliccost, newsolutionfitness)

    return newtargetset, newsolutionfitness
