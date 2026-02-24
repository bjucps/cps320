import qrcode
import os

def gen_QR(url):
    # --- Settings ---
    folder = os.getcwd()  # Folder to save the image
    filename = "qr.png"  # Name of the QR code file

    # --- Make sure the folder exists ---
    os.makedirs(folder, exist_ok=True)

    # --- Full path for saving ---
    path = os.path.join(folder, f"static/{filename}")

    # --- Create QR code ---
    qr = qrcode.QRCode(
        version=1,  # Size of QR code: 1 is small, 40 is large
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(url)
    qr.make(fit=True)

    # --- Generate and save image ---
    img = qr.make_image(fill_color="black", back_color="white")
    img.save(path)

    # --- Confirm that it saved ---
    if os.path.exists(path):
        print(f"✅ QR code saved successfully at: {path}")
    else:
        print("❌ Failed to save QR code")

if __name__ == '__main__':
    gen_QR("test.com")
