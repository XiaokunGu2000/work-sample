import copy
import math
import random
import numpy as np
import matplotlib.pyplot as plt
from functools import cmp_to_key



PW = 0.1
N0 = 0.1 / 49000000
threshold = 1
width = 200


# 这个类用来更新位置信息
class Coordinate:
    def __init__(self, f, t):
        # I add a timer here
        self.f = f
        self.t = t

class SCoordinate:
    def __init__(self, x, y):
        # I add a timer here
        self.x = x
        self.y = y

class SPSsort:
    def __init__(self,Coordinate1,value):
        self.Coordidnate1 = Coordinate1
        self.value = value

def cmpsort(a,b):
    if a.value < b.value:
        return -1
    else:
        return 1

#This function is used to judge whether the communication between 2 vehicles is valid
def situationdef(c1, c2):
    # print(math.ceil(rangex / 2) + width)
    if(c1.x == c2.x or c1.y == c2.y or (((c1.x > math.ceil(rangex / 2) - width) and (c1.x < math.ceil(rangex / 2) + width)) and ((c1.y > math.ceil(rangex / 2) - width) and (c1.y < math.ceil(rangex / 2) + width)))):
        return True
    if(c1.x <= math.ceil(rangex / 2) - width):
        k = (c2.y - c1.y) / (c2.x - c1.x) * 1.0
        verifyx = c1.x + math.fabs(width / k * 1.0)
        if(verifyx <= (math.ceil(rangex / 2) - width)):
            return False
        else:
            return True
    elif(c1.x >= math.ceil(rangex / 2) + width):
        k = (c2.y - c1.y) / (c2.x - c1.x) * 1.0
        verifyx = c1.x - math.fabs(width / k * 1.0)
        if (verifyx >= (math.ceil(rangex / 2) + width)):
            return False
        else:
            return True
    elif (c1.y <= math.ceil(rangex / 2) - width):
        k = (c2.y - c1.y) / (c2.x - c1.x) * 1.0
        verifyy = c1.y + math.fabs(width * k * 1.0)
        if (verifyy <= (math.ceil(rangex / 2) - width)):
            return False
        else:
            return True
    elif (c1.y >= math.ceil(rangex / 2) + width):
        k = (c2.y - c1.y) / (c2.x - c1.x) * 1.0
        verifyy = c1.y - math.fabs(width * k * 1.0)
        if (verifyy >= (math.ceil(rangex / 2) + width)):
            return False
        else:
            return True

time_slots=20

freq_bands=5

sharechannel = np.zeros((freq_bands, time_slots))


class Car:

    def __init__(self, hearingrange = 7000, position = SCoordinate(0,0) ,time_slots=20, freq_bands=5 , channelresource = np.zeros((freq_bands, time_slots))):


        # new things
        self.position = position
        self.transmissionnum = 0

        self.hearingrange = hearingrange

        self.hearinglist = []

        # I add a timer here
        self.time_slots = time_slots

        self.freq_bands = freq_bands
        self.data = channelresource
        self.datad = np.zeros((freq_bands, time_slots))
        # tmarker and fmarker is the marker of the transmission/index of the communication resources
        self.tmarker = random.randint(0, self.time_slots - 1)
        self.fmarker = random.randint(0, self.freq_bands - 1)

        self.timer = random.randint(5,15)
        self.count = 0
        self.success = 0
        self.collision = 0


    def calculatenoise(self):
        SORTlist = []
        result = []
        self.datad[:] = 0
        for w in self.hearinglist:
            dist = math.sqrt((self.position.x - w.position.x) ** 2 + (self.position.y - w.position.y) ** 2)
            self.datad[w.fmarker][w.tmarker] += PW / (dist ** 2)

        for w in range(freq_bands):
            for t in range(time_slots):
                SORTlist.append(SPSsort(Coordinate(w, t), self.datad[w][t]))

        SORTlist.sort(key=cmp_to_key(cmpsort))
        for i in range(math.floor(0.2 * (time_slots * freq_bands))):
            result.append(SORTlist[i].Coordidnate1)

        return result

    # I add a relocate mode to this function
    def transmit_randomSPS(self):

        # here is the situation when the timer goes to zero
        if self.timer == 0:

            store = self.calculatenoise()
            index = random.randint(0,len(store) - 1)
            self.fmarker = store[index].f
            self.tmarker = store[index].t


            self.timer = random.randint(5,15)


            self.transmit0()
        # here is the situation when the timer is not zero
        else:
            self.transmitn0()


    # transmission when self.timer ！= 0
    def transmitn0(self):
        dist = 0
        for car in self.hearinglist:
            if(situationdef(self.position, car.position)):
                store = car.calculatenoise()
                dist = math.sqrt((self.position.x - car.position.x) ** 2 + (self.position.y - car.position.y) ** 2)

                if(car.datad[self.fmarker][self.tmarker] != 0):
                    TARGET = PW / (dist ** 2)
                    NOISE = car.datad[self.fmarker][self.tmarker] - (PW / (dist ** 2))
                    SINR = (PW / (dist ** 2)) /(car.datad[self.fmarker][self.tmarker] - (PW / (dist ** 2)) + N0)
                else:
                    SINR = (PW / (dist ** 2)) / (N0)
                car.count += 1
                if(SINR >= threshold):
                    car.success += 1
                else:
                    car.collision += 1

        self.timer = self.timer - 1

    # transmission when self.timer == 0
    def transmit0(self):
        dist = 0
        for car in self.hearinglist:
            if (situationdef(self.position, car.position)):
                store = car.calculatenoise()
                dist = math.sqrt((self.position.x - car.position.x) ** 2 + (self.position.y - car.position.y) ** 2)
                if (car.datad[self.fmarker][self.tmarker] != 0):
                    SINR = (PW / (dist ** 2)) / (car.datad[self.fmarker][self.tmarker] - (PW / (dist ** 2)) + N0)
                else:
                    SINR = (PW / (dist ** 2)) / (N0)
                car.count += 1
                if (SINR >= threshold):
                    car.success += 1
                else:
                    car.collision += 1

    #rellocate communication resources
    def adjust(self):
        self.tmarker = random.randint(0, self.time_slots - 1)
        self.fmarker = random.randint(0, self.freq_bands - 1)




# Loop over all iterations, each time increasing the number of transmit cars

def cmp1(a,b):
    if a.position.x < b.position.x:
        return -1
    else:
        return 1

def cmp2(a,b):
    if a.position.y < b.position.y:
        return -1
    else:
        return 1


Car_num = 100
rangex = 10000
Number_Time_Interval = 250

k = []


first_selection = []

# list of the successful rate/collision rate of all the vehicles
collisionsum = []
successsing = []

# success rate for each frame
rate = []


intersection = []
#change the position of obstacle
for width in range(1000,2500,100):
    carset = []
    collisionsum = []
    successsing = []
    for i in range(Car_num):
        if i < math.ceil(Car_num/2):
            m = Car()
        # m.marker = Coordinate(m.fmarker , m.tmarker)
            m.position = SCoordinate(math.floor(rangex / Car_num * 2) * i,math.ceil(rangex / 2))
            carset.append(m)
        elif i < math.ceil((Car_num / 4) * 3):
            m = Car()

            m.position = SCoordinate(math.ceil(rangex / 2), math.floor((rangex - 10) / Car_num * 2) * (i - math.ceil(Car_num/2)))
            carset.append(m)

        else:
            m = Car()

            m.position = SCoordinate(math.ceil(rangex / 2), 10 + math.floor((rangex) / Car_num * 2) * (i - math.ceil(Car_num / 2)))
            carset.append(m)




    carsetx = carset[0:math.ceil(Car_num/2)]
    carsety = carset[math.ceil(Car_num/2) : Car_num]
    carsetx.sort(key=cmp_to_key(cmp1))
    carsety.sort(key=cmp_to_key(cmp2))
    carset = []
    carset.extend(carsetx)
    carset.extend(carsety)

    # for i in range(Car_num):
    #     print(carset[i].position.x, carset[i].position.y)

    collisionsum = []
    successsing  = []
    for m in range(len(carset)):

        car = carset[m]
        collisionsum.append([])
        successsing.append([])

        for i in range(m+1, len(carset)):
            car2 = carset[i]
            distance = abs(car.position.x - car2.position.x) ** 2 + abs(car.position.y - car2.position.y) ** 2
            if(distance <= car.hearingrange ** 2):
                car.hearinglist.append(car2)
                car2.hearinglist.append(car)





    for i in range(Number_Time_Interval):

        for x in carset:

            x.transmit_randomSPS()


        for i in range(len(carset)):
            x = carset[i]
            if (x.count == 0):
                continue

            collisionsum[i].append(x.collision/x.count)
            successsing[i].append(x.success/x.count)




        for w in carset:
            w.datad[:][:] = 0




    for i in range(Car_num):
        if(len(collisionsum[i]) == 0):
            continue
        avr = np.sum(collisionsum[i])/len(collisionsum[i])
        avr1 = np.sum(successsing[i]) / len(successsing[i])
        collisionsum[i] = avr
        successsing[i] = avr1

    sum = 0
    countd = 0
    for i in range(Car_num):
        if((((carset[i].position.x - math.ceil(rangex/2)) ** 2 + (carset[i].position.y - math.ceil(rangex/2)) ** 2) <= 9000000) and ((((carset[i].position.x - math.ceil(rangex/2)) ** 2 + (carset[i].position.y - math.ceil(rangex/2)) ** 2)) >= 4000000)):
            sum += successsing[i]
            countd += 1
    intersection.append(sum / countd * 1.0)
    print(Car_num)


k2 = []

for i in range(len(intersection)):
    k2.append(1000 + i * 100)

plt.plot(k2,intersection, label = 'success')
plt.ylabel("the average PRR of the cars(2000-3000m from the intersection)")
plt.xlabel("distance of the building from the road")
plt.legend()
plt.ylim(0,1)
plt.show()