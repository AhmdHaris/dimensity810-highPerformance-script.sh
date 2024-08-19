# dimensity810-highPerf.sh

**Description**

This script is designed to activate High Performance by locking CPU, GPU frequencies and activating other features to help increase performance on the MediaTek Dimensity 810 

**Attention:**

**Please Do With Ur Own RISK**

* **Overclocking** can increase device temperature and reduce component life. Use it wisely and responsibly.
* **This script may not be compatible with all devices that use Dimensity 810 depending on the Kernel Version, ROM etc. (but I will try to make this script compatible on all devices that use Dimensity 810)** Tested on Infinix HOT 20 5G With XOS 10.6.0, Android 12, Kernel 4.19 .

*  ### **Features in this script**
*  CPU/GPU Boost + Max
CPU : Lock 2400MHz (A76), Lock 2000MHz (A55)
*  Set CPU Governor Little & Big to Performance
*  GPU : Lock 1068MHz **Max Freq**
*  CPU Sports Mode, HMP Mode
*  GPU Power Policy : always_on
* ~~Enable Game Touch Sampling~~
* ~~Disable Oplus Limit TP for best experience gaming~~
*  Disable Thermal 
*  Enable GED Modules from MediaTek
*  Stop logcat feature to reduce CPU Usage
*  TCP : cubic (Ping more stable)
*  Enable TCP Low Latency
*  I/O : mq-deadline (nearby real-time) **kernel with 4.19**
*  I/O : deadline **kernel with 4.14** 
*  VM : Clear RAM Cache aggressive (3/3)
*  APUs : 

### **How To Install** (using Termux)
1. **Give root/superuser permission to the app**
2. **Clone repository:**
   ```bash
   git clone https://github.com/AhmdHaris/dimensity810-highPerformance-script.sh.git
3. **Open directory script**
```
cd dimensity810-highPerformance-script.sh
```
4. **Run The Script**
```
sudo bash dimensity810-highPerf-script.sh
```
5. **Done**
