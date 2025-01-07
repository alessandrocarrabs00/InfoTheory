from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives import padding
import os
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import random
import numpy as np
from PIL import Image




# padder fa in modo aggiungere blocchi si byte per essere divisibile per 16, quando si vuole farlo 
# padded_data = padder.update(data) + padder.finalize()
#da intendere come oggetto 
padder = padding.PKCS7(128).padder()

# point 1

def read_file(file_path):
    with open(file_path, "rb") as penguin: 

        H1 = penguin.readline()
        H2 = penguin.readline()
        H3 = penguin.readline()
        H4 = penguin.readline()

        watermark = H1 + H2 + H3 + H4 
        plaintext = penguin.read()

    return plaintext, watermark 

def write_encr_file(file_path, watermark, encr_data): 
    with open(file_path, "wb") as penguin: 
        penguin.write(watermark)
        penguin.write(encr_data)


def cipher(key, mode, data_padded, watermark, bn):

    vet = os.urandom(16)

    if mode  == "ECB":
        cipher_ecb = Cipher(algorithms.AES(key), modes.ECB())
    elif mode == "CBC": 
        cipher_ecb = Cipher(algorithms.AES(key), modes.CBC(vet))
    elif mode == "CTR": 
        cipher_ecb = Cipher(algorithms.AES(key), modes.CTR(vet))
    else: 
        print("choose between ECB, CBC, CTR mode")
        return
    
    encr_ecb = cipher_ecb.encryptor()
    encr_ecb = encr_ecb.update(data_padded) + encr_ecb.finalize()

    file_out = bn + "_" + mode + ".ppm"
    write_encr_file(file_out, watermark, encr_ecb)

    if mode == "ECB": 
        return file_out
    else: 
        return file_out,vet 


# point 2: what happen when have you changed the key
def change_bits_ecb(key):
    #rewrite the key in bitstream
    new_key = ''.join(f"{byte:08b}" for byte in key)  # every byte in 8 bit
    bits_index = random.sample(range(0, 127), 3)
    print(f"the bits are going to change: {bits_index}\n")
    new_key = list(new_key)
    for i in bits_index:
        if  new_key[i] == "0":
            new_key[i] = "1"
        else:
            new_key[i] = "0" 
    

    new_key = bytes(
    int(''.join(map(str, new_key[i:i + 8])), 2)
    for i in range(0, len(new_key), 8)
)


    return new_key



def visualize(file):
    

    img = mpimg.imread(file)

    plt.imshow(img)
    plt.axis('off')
    plt.show()






visualize("Tux.ppm")
file_path = "Tux.ppm"
data, watermark = read_file(file_path)
data_padded = padder.update(data) + padder.finalize();


# creating a random key, in byte
key = os.urandom(16)

file_ECB = cipher(key, "ECB", data_padded, watermark, "Tux")

file_CBC, iv0 = cipher(key, "CBC", data_padded, watermark, "Tux")
file_CTR, iv1  = cipher(key, "CTR", data_padded, watermark, "Tux")



#visualize(file_ECB)
#visualize(file_CBC)
#visualize(file_CTR)






# point 2 new key (with 3 bit changed) for ECB 

new_key = change_bits_ecb(key)
new_file_ECB = cipher(new_key, "ECB", data_padded, watermark, "new_Tux")

#visualize(new_file_ECB)



# point 3 decrypting the cbc and ctr mode

def decrypt(key, vet, file_enc, mode):
    if mode == "CBC":
        c = Cipher(algorithms.AES(key), modes.CBC(vet))
    elif mode == "CTR":
        c = Cipher(algorithms.AES(key), modes.CTR(vet))
    else: 
        print("error for mode decryption")
        return
    
    plaintext = c.decryptor()
    plaintext = plaintext.update(file_enc) + plaintext.finalize()

    return plaintext;



iv = os.urandom(16)

file_enc_cbc, watermark = read_file(file_CBC)
plaintext = decrypt(key, iv, file_enc_cbc, "CBC")
write_encr_file("file_enc_cbc0.ppm", watermark, plaintext)
#visualize("file_enc_cbc0.ppm")


file_enc_ctr, watermark = read_file(file_CTR)
plaintext = decrypt(key, iv, file_enc_ctr, "CTR")
write_encr_file("file_enc_ctr0.ppm", watermark, plaintext)
#visualize("file_enc_ctr0.ppm")
























