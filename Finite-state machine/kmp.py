import sys

def ComputePrefixFunction(pattern):
    m = len(pattern)
    pi = [0 for p in pattern]
    k = 0
    for q in range(1,m):
        while k>0 and pattern[k] != pattern[q]:
            k = pi[k-1]
        if pattern[k] == pattern[q]:
            k += 1
        pi[q] = k
    print(pi)
    return pi

def KmpMatcher(text,pattern):
    n = len(text)
    m = len(pattern)
    pi = ComputePrefixFunction(pattern)
    q = 0
    position = []
    for i in range(n):
        while q>0 and pattern[q] != text[i]:
            q = pi[q-1]
        if pattern[q] == text[i]:
            q += 1
        if q == m:
            position.append(i-m+1)
            q = pi[q-1]
    print(position)

if __name__ == "__main__":
    pattern = sys.argv[1]
    with open(sys.argv[2], encoding="utf-8") as file:
        text = file.read()
    alphabet = {a for a in text}   
    print("Pattern: ", pattern)
    KmpMatcher(text,pattern)