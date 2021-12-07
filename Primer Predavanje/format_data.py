import os

def format_data(path,rezName):
    rez = open(rezName,"w")
    with open(path,"r") as opened_file :
        line = opened_file.readline()
        while(line):
            colums = line.split('\t')
            newLine = colums[0]
            colums.pop(0)
            for colum in colums :
                colum = str.strip(colum)
                newLine = newLine + "," + colum 
            rez.write(newLine + "\n")
            line = opened_file.readline()       
    rez.close()
    print("[M] Formatting completed!")

if __name__ == "__main__":
    format_data("diabetes.data","diabetes.csv")


