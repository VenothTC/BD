import sys
from pathlib import Path
# go up 2 folders 
project_root = Path(__file__).resolve().parents[2]
sys.path.append(str(project_root))


from utils.logger import get_logger, print


logger = get_logger("shopping_cart1")


# display menu of shopping items
stock = {
    # ID: [product_name, quantity, cost per item]
    1 : ["Biscuits", 5, 20.5],
    2 : ["Cereals", 10, 90],
    3 : ["Chicken", 20, 100],
    4 : ["Beef", 20, 400],
}
cart ={} # empty

def add_to_cart(cart, add_id, qty):
    if add_id in cart: # adding on to item alrdy in cart
        if cart[add_id][1]+qty <= stock[add_id][1]:
            cart[add_id][1] += qty
            print(f"Added: {cart[add_id]}")
        else:
            print("Not valid Quantity, item overflow")
            return False
    else: # item not in cart, adding new item to cart
        if 0< qty <= stock[add_id][1]:
            
            cart[add_id] = [stock[add_id][0], qty,stock[add_id][2] ]
            print(f"Added {cart[add_id]} to cart")
        else:
            print("Not valid quantity")
            return False
    return True
    
def print_items(c):
    print(f"Id\tItem\t\tQuantity\t    $/unit")
    for k, v in c.items():
            print(f" {k:<5} {v[0]:<15}\t{v[1]:<10}\t{v[2]:10}")

shopping = True
adding_items = True

# while shopping:
# add items to cart and keep going
while adding_items:
    
    print_items(stock)
    id = int(input("Enter id of product you would like to add:  "))

    if id in stock: # check valid id
        mssg = f"{stock[id][1]} {stock[id][0]}'s in stock, priced at {stock[id][2]}$ per unit"
        qty = int(input(mssg + "\nHow many would you like to purchase: "))
        if not add_to_cart(cart,id, qty): 
            print("Try again")
            continue
        else:
            while True:
                print("Current Cart:")
                print_items(cart)
                ans = input(f"Would you like to add more items(Y/N)? ").lower()
                if ans not in ("y","n"):
                    print("invalid input, try again buddy")
                    continue
                else:
                    break
            if ans == "y":
                continue
            elif ans == "n":
                adding_items=False                    
                break            
    else:
        print("Sorry, invalid id please try again")
    
print(f"Done Shopping! You Current Cart:")
print_items(cart)
name = input("Enter First and Last nam: ")
address = input("Enter address: ")
distance = int(input("Enter distance from store(5/10/15/20/25/30): "))

if distance <= 15:
    print("Delivery Charge 50$ because under 15km")
    delivery_fee = 50
elif 15 < distance <= 30:
    print("Delivery Charge 100$ because beween 15km and 30km")
    delivery_fee = 100
else: 
    sys.exit("Sorry! We only deliver up a 30km range and can not deliver to your place, thanks for playing")

print("----------------------------Bill---------------------------")
total = 0
counter =1
print(f"S.No   Item\t\tQty\t$/unit\t\t\tTotal")
for k, v in cart.items():
    total+= (v[1]*v[2])
    print(f" {counter:<5}{v[0]:<15}\t{v[1]:<5}\t{v[2]:<10}\t\t{float(v[1]*v[2]):.2f}")
    counter+=1
    
print(f"\nTotal item cost: {total:.2f}")
print(f"Total Bill(plus Delivery): {total:.2f} + {delivery_fee:.2f} =  {total+delivery_fee:.2f}.")
print(f"Name: {name}")
print(f"Delivery Address: {address}")
print(f"Have a nice Day")
    
    
        
