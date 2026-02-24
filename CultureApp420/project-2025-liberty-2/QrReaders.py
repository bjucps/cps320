from qreader import QReader
import cv2


# Create a QReader instance
qreader = QReader()

# Get the image that contains the QR code
image = cv2.cvtColor(cv2.imread("program\image.png"), cv2.COLOR_BGR2RGB)

# Use the detect_and_decode function to get the decoded QR data
decoded_text = qreader.detect_and_decode(image=image)

#This may be something that Docker needs to do, but there are a few dependencies that need to be installed for it to work and it 
# also needs the code to tell it what its suppose to do after it decodes the QR
#"pip install qreader" is the library used to run it