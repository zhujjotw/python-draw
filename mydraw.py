'''
Author: 朱佳佳
Date: 2021-05-13 13:01:14
LastEditTime: 2021-05-14 09:14:51
LastEditors: Please set LastEditors
Description: python脚本根据top生成信息绘制free+cache折线图
'''
import mygrep
import os
import matplotlib.pyplot as plt
from matplotlib.pyplot import MultipleLocator
import numpy as np

#画线的条数
linecnt=2
#需要解析的文件名，不支持中文路径名，一个文件一条线
#如果路径是\,需要在前面加上r转义 example filename=[r“C:\Users\Administrator\Desktop\installpython”]
filename=[r"E:\top\top202005.txt", r"E:\top\top202005.txt", "cc.txt"]
#折线名称
linename=["113", "115"]
#坐标轴颜色配置
# ‘b’	blue
# ‘g’	green
# ‘r’	red
# ‘c’	cyan
# ‘m’	magenta
# ‘y’	yellow
# ‘k’	black
# ‘w’	white
color=['r','b']
#保存下来的图片的名称
picname="pic.jpg"

#获取具体的参数值
def ParseStr(str):
    content=str.split(" ", 10)
    keyword1=int(content[3][0:len(content[3])-1])
    keyword2=int(content[9][0:len(content[9])-1])
    keyword3=keyword1+keyword2
    print(keyword3)
    return keyword3

def GenreateTmpFiles(tmpfilename):
    i = 0
    cmd=[]
    while i < linecnt :
        cmd = 'python mygrep.py free, %s' %filename[i]
        print(cmd)
        os.system(cmd)
        tmpfilename[i]='%stmp.txt' %filename[i]
        i = i + 1

def RmTmpFiles(path):
    i = 0
    while i < linecnt :
        os.remove(path[i])
        i = i + 1

def GetKeyWord(path,X,Y):
    i = 0
    while i < linecnt:
        fo=open(path[i], 'r')
        j=0
        while 1:
            j = j+1
            line = fo.readline(100)
            if len(line) ==0 :
                break
            print(line)
            X[i].append(j)
            Y[i].append(ParseStr(line))
        fo.close()
        i = i + 1

def CoordinateAxisCfg(xmin,xmax,ymin,ymax,X,Y):
    plt.figure(figsize=(25,20))
    plt.xlim([xmin,xmax])  # x轴边界
    plt.ylim([ymin,ymax])  # y轴边界
    x = np.linspace(0,(xmax/10 + 1)*10,int(xmax/10)) #刻度取整
    i = 0
    for i in range(linecnt):
        plt.plot(X[i],Y[i],color[i],label=linename[i])#o-:圆形
        i += 1
    plt.legend(linename, loc = "best")#图例
    plt.rcParams['font.sans-serif']=['SimHei'] # 中文
    
    plt.xlabel("时间")
    plt.ylabel("free+cache")

    x_major_locator=MultipleLocator(200)
    #把x轴的刻度间隔设置为1，并存在变量里
    y_major_locator=MultipleLocator(1000)
    #把y轴的刻度间隔设置为10，并存在变量里
    ax=plt.gca()
    #ax为两条坐标轴的实例
    ax.xaxis.set_major_locator(x_major_locator)
    # #把x轴的主刻度设置为1的倍数
    ax.yaxis.set_major_locator(y_major_locator)
    ax.xaxis.grid(True, which='major')   # x坐标轴的网格使用主刻度
    ax.yaxis.grid(True, which='major')   # y坐标轴的网格使用次刻度
    plt.savefig(picname)
    plt.show()

def VarInit():
    axis=[]
    i = 0
    j = 0
    for i in range(linecnt):                            
        axis.append([])                               
    return axis

def main():
    tmpfilename = []
    i = 0
    for i in range(linecnt):
        tmpfilename.append(0)
    X= VarInit().copy()
    Y = VarInit().copy()
    GenreateTmpFiles(tmpfilename)
    GetKeyWord(tmpfilename, X,Y)
    CoordinateAxisCfg(0,len(X[0]),Y[0][len(Y[0])-1]-3000, Y[0][0]+1000,X,Y) 
    RmTmpFiles(tmpfilename)
    exit()

        
if __name__ == '__main__':
    main()

