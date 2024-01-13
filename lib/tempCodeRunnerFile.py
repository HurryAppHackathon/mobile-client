N = input()

b = input()


l = b.split(' ')
l = [int(i) for i in l]
    
l.sort()
r =""

r=" ".join(str(l))

print(r)



