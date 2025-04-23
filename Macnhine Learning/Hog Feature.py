import autograd.numpy as np
import matplotlib.pyplot as plt
from autograd import grad
from autograd import hessian
import math
import glob
import random
import cv2
import tensorflow as tf
import skimage


def path(all_img_path):
    train = []
    for path in all_img_path:
        imgg = cv2.imread(path)
        # cv2.imshow('ORIGINAL',img)
        imgg = cv2.cvtColor(imgg,cv2.COLOR_RGB2GRAY)
        imgg = skimage.img_as_float(imgg)
        # img = (img - img.min()) * (1 / (img.max() - img.min()))
        mat = np.array(cv2.resize(imgg,(128,128)))
        fd, hogimage = skimage.feature.hog(mat, orientations=8, pixels_per_cell=(8, 8),
                                           cells_per_block=(1, 1), visualize=True)

        train.append(hogimage.flatten())
    return train

def path1(all_img_path):
    train = []
    for path in all_img_path:
        imgg = cv2.imread(path)
        # cv2.imshow('ORIGINAL',img)
        train.append(imgg)
    return train


# 按间距中的绿色按钮以运行脚本。

train_image_path = glob.glob("dc/train/*.jpg")
trcp = [s for s in train_image_path if s.split('\\')[-1].split('.')[0]=="cat" ]
trdp = [s for s in train_image_path if s.split('\\')[-1].split('.')[0]!="cat" ]
    #准备测试集数据

tdp = trcp[400:550]
tcp = trdp[500:650]
tcp.extend(tdp)
random.shuffle(tcp)
testla = [s.split('\\')[-1].split('.')[0] for s in tcp]
testda = path(tcp)
label = {'dog': 0, 'cat': 1}
testy = [label.get(l) for l in testla]



#####准备训练集数据
trcp = trcp[:500]
trdp = trdp[:500]
trcp.extend(trdp)
trip = trcp
random.shuffle(trip)
trainlabel = [s.split('\\')[-1].split('.')[0] for s in trip]
trainy = [label.get(l) for l in trainlabel]
dataArr = path(trip)
eSum = 0.0
dataArr = np.array(dataArr).T
testda = np.array(testda).T
trainy = np.array(trainy)
trainy = trainy.reshape(1,trainy.size)
testy = np.array(testy)
testy = testy.reshape(1,testy.size)


testre = path1(tcp)



def model(x, w):
    a = w[0] + np.dot(x.T, w[1:])
    return a.T

    # def model(x, w):
    #     a = np.dot(x.T, w)
    #     return a.T

def sig(t):
    m = t
    n = np.exp(-t)
    return 1/(1 + np.exp(-t))

def sigmoid(w):
    a = sig(model(dataArr,w))
    ind = np.argwhere(trainy == 0)[:,1]
    cost = -np.sum(np.log(1 - a[:,ind]))
    ind = np.argwhere(trainy == 1)[:, 1]
    cost -= np.sum(np.log(a[:, ind]))

    return cost/trainy.size


def stocGradAscent2(w, alpha, Epoch=200):
    gradient = grad(sigmoid)
    weight = [w]
    cost = [sigmoid(w)]
    for i in range(1, Epoch + 1):
        gradtemp = gradient(w)
        w = w - alpha * gradtemp
        weight.append(w)
        cost.append(sigmoid(w))
    return weight[len(weight) - 1]

def classify(inX, weights):
    return sig(model(inX, weights))


def Test(inX, weights, y):
    temp = 0
    indf = classify(inX, weights)
    for i in range(0, indf.size):
        if (indf[0, i] < 0.5):
            indf[0, i] = 0
        else:
            indf[0, i] = 1
    for i in range(0, y.size):
        if (indf[0, i] != y[0,i]):
            temp += 1
    return float(temp) / y.size

def RESULT(inX, weights, y):
    temp = 0
    indf = classify(inX, weights)
    for i in range(0, indf.size):
        if (indf[0, i] < 0.5):
            indf[0, i] = 0
        else:
            indf[0, i] = 1
    return indf


def DCTest(train, test, testL):
    original = np.random.rand(train.shape[0] + 1, 1) * 0.001
    trainWs = stocGradAscent2(original, 2.7,500)
    error = Test(test, trainWs, testL)
    result = RESULT(test, trainWs, testL)
    for i in range(0, testL.size):
        if result[0, i] != testL[0, i]:
            plt.imshow(testre[i])

    print(f"The accuracy is:{1 - error}")
    return error


for k in range(10):
    eSum += DCTest(dataArr, testda, testy)
print("%d times，the average accuracy is %f" % (10, 1 - eSum / float(10)))