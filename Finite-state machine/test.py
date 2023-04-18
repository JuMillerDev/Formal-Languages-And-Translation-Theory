
if __name__ == '__main__':
    d = {(q): 0 for q in range(1000)}
    d[0] = 1
    print(d)
    arr = [0]*1000
    print(arr)
    counter = sum(v == 0 for v in d.values())
    print("max: ", max(d.values()))
    print(all(v == 0 for v in d.values()))
    print(counter)
    dic = {1:2, 2:3, 3:4}
    print(all(x>=1 for x in dic.values()))
    