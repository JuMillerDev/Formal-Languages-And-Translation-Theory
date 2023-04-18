import sys

def FiniteAutomationMatcher(text,transition,m):
    n = len(text)
    q = 0
    position = []
    for i in range(n):
        q = transition[q,text[i]]
        if q == m:
            position.append(i-m+1)
    print(position)

def ComputeTransitionFunction(pattern, alphabet):
    m = len(pattern)
    d = {(q, a): 0 for q in range(m + 1) for a in alphabet}
    for q in range(m+1):
        for a in alphabet:
            k = min(m, q+1)
            while k > 0 and pattern[:k] != (pattern[:q]+a)[-k:]:
                k -= 1
            d[q,a] = k
    print(d)
    return d

if __name__ == '__main__':
    pattern = sys.argv[1]
    with open(sys.argv[2], encoding="utf-8") as file:
        text = file.read()
    alphabet = {a for a in text}
    print("Pattern: ", pattern)
    FiniteAutomationMatcher(text, ComputeTransitionFunction(pattern,alphabet), len(pattern))