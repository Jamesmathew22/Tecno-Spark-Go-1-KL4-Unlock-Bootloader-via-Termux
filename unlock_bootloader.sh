#!/data/data/com.termux/files/usr/bin/bash
# ============================================
# Tecno KL4 Bootloader Unlock Script (Unisoc T615)
# Termux version by ChatGPT (replaces .bat/.exe)
# ============================================

echo ""
echo "🔓 Tecno KL4 Bootloader Unlock (Unisoc T615)"
echo "=============================================="
echo ""

# Check if running as proper Termux environment
if ! command -v python >/dev/null 2>&1; then
  echo "❌ Python not found. Run this first:"
  echo "pkg install git python usbutils -y"
  exit 1
fi

# Step 1: Clone SPD tool if not found
if [ ! -d "spreadtrum_flash" ]; then
  echo "📥 Cloning Spreadtrum Flash Tool..."
  git clone https://github.com/TomKing062/spreadtrum_flash.git || {
    echo "❌ Failed to clone repo. Check internet connection."
    exit 1
  }
fi

cd spreadtrum_flash || exit 1

# Step 2: Check USB connection
echo ""
echo "🔌 Connect your Tecno KL4 via OTG (powered off)"
echo "Then press ENTER when ready..."
read -r

lsusb | grep -i "Spreadtrum" >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "⚠️  No Spreadtrum device detected."
  echo "Hold Vol+ and Vol–, plug in the cable, then try again."
  exit 1
fi

# Step 3: Install dependencies
echo ""
echo "⚙️  Installing Python requirements..."
pip install -r requirements.txt >/dev/null 2>&1

# Step 4: Start unlock process
echo ""
echo "🚀 Unlocking bootloader... Please wait."

# Adjust paths if you copied your BIN files into this directory
python spd_dump.py exec --fdl1 ../fdl1-dl.bin --fdl2 ../fdl2-dl.bin unlock

if [ $? -eq 0 ]; then
  echo ""
  echo "✅ Bootloader Unlock Completed Successfully!"
  echo "Your Tecno KL4 should now be unlocked."
else
  echo ""
  echo "⚠️  Unlock may have failed. Try running the script again."
fi

echo ""
echo "Done!"
