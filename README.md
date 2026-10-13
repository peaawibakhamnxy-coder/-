# 🔍 OmniReverse OSINT Pro — Cross-Platform Reverse Image Search & Social Media Hub

โปรแกรม Desktop สำหรับค้นหาข้อมูลจากรูปภาพเพียงรูปเดียวข้ามทุกแพลตฟอร์ม (**Google, Instagram, Facebook, Discord, Yandex, Bing, TinEye, FaceCheck.id**) พร้อมระบบวิเคราะห์ข้อมูลทางดิจิทัลฟอเรนสิกส์ (EXIF Metadata, MD5, SHA-256 Checksum)

![OmniReverse Logo](assets/logo.jpg)

---

## 🚀 วิธีการเปิดใช้งานโปรแกรม

คุณสามารถเปิดโปรแกรมได้ง่ายๆ 2 วิธี:

### วิธีที่ 1: ดับเบิลคลิกไฟล์ตัวเปิดใช้งาน (แนะนำที่สุด)
- ดับเบิลคลิกที่ไฟล์ **`Launch-OmniReverse.bat`**
- โปรแกรมจะเปิดหน้าต่าง Desktop สไตล์ Dark Cyberpunk ทันทีโดยไม่มีหน้าต่าง Command Prompt ดำๆ ค้างอยู่

### วิธีที่ 2: สร้างไอคอนทางลัดไว้บนหน้าจอ Desktop
- คลิกขวาที่ไฟล์ **`Create-Desktop-Shortcut.ps1`** แล้วเลือก **Run with PowerShell**
- จะมีไอคอนทางลัดชื่อ **`OmniReverse OSINT`** ปรากฏบนหน้าจอ Desktop ของคุณทันที

---

## 🎯 กลไกการค้นหาแต่ละแพลตฟอร์มทำงานอย่างไร?

| แพลตฟอร์ม | กลไกที่ระบบใช้ค้นหา | ผลลัพธ์ที่ได้ |
|---|---|---|
| **🔍 Google Lens** | Visual Search Engine + OCR Scanner | ค้นหาเว็บต้นทาง, บุคคล, แหล่งข่าว และดึงข้อความจากในภาพ |
| **📸 Instagram** | Google Dork (`site:instagram.com`) + Yandex Social Index | เจาะหาโปรไฟล์และโพสต์บน IG ที่เคยใช้รูปนี้ |
| **👥 Facebook** | Bing Visual Index + Facebook Search Dork (`site:facebook.com`) | ค้นหาภาพโปรไฟล์, เพจสาธารณะ, กลุ่ม และโพสต์บน Facebook |
| **💬 Discord** | CDN Hash Matching + Discord Server/Attachment Dork + Instant Clipboard | ตรวจสอบไฟล์แนบ Discord CDN, ค้นหาเซิร์ฟเวอร์ และก็อปปี้รูปลงคลิปบอร์ดให้กด `Ctrl+V` วางในแชทได้ทันที |
| **🌐 Yandex Visual** | Advanced Neural Facial & Object Search | **แนะนำสูงสุดสำหรับหาบัญชีโซเชียล**: แม่นยำที่สุดในการจับคู่ใบหน้ากับ IG / FB |
| **🟦 Microsoft Bing** | Microsoft Visual Search Engine | ค้นหาบุคคล, สินค้า, สถานที่ และวัตถุในภาพ |
| **👁️ TinEye** | Exact Fingerprint Matcher | ค้นหาภาพต้นฉบับดั้งเดิม (Original) และตรวจสอบวันที่ภาพปรากฏบนเว็บเป็นครั้งแรก |
| **👤 FaceCheck.id / PimEyes** | AI Facial Recognition OSINT | สแกนหาใบหน้าบุคคลข้ามโซเชียลมีเดีย (Instagram, Facebook, TikTok, Twitter/X, OnlyFans) |

---

## ⚡ ฟีเจอร์เด่นภายในโปรแกรม

1. **ใส่รูปได้หลายวิธีสะดวกสุดๆ:**
   - **Drag & Drop:** ลากไฟล์รูปจากเครื่องมาหย่อนลงในโปรแกรมได้ทันที
   - **Browse File:** กดเลือกไฟล์จากคอมพิวเตอร์
   - **Paste from Clipboard (Ctrl+V):** สามารถแคปหน้าจอ (Win + Shift + S) แล้วกดวางได้ทันที ไม่ต้องเซฟไฟล์ก่อน
2. **เลือกโหมดการค้นหาได้ 2 รูปแบบ:**
   - ☁️ **Auto Cloud Upload:** อัปโหลดภาพขึ้นเซิร์ฟเวอร์ชั่วคราว (ลบอัตโนมัติภายใน 1 ชั่วโมงเพื่อความเป็นส่วนตัว) เพื่อให้ Search Engine ดึง URL ไปค้นหาได้ทันที
   - 📋 **Direct Clipboard (Offline/Privacy Mode):** ไม่มีการอัปโหลดภาพขึ้นเซิร์ฟเวอร์ใดๆ ภาพจะถูกคัดลอกลงคลิปบอร์ดของ Windows ให้คุณกด `Ctrl+V` วางลงใน Search Engine ได้เอง
3. **One-Click Multi-Search (🚀):**
   - ติ๊กเลือกแพลตฟอร์มที่ต้องการ แล้วกดปุ่มเดียวเพื่อเปิดแท็บค้นหาพร้อมกันทั้งหมด
4. **Digital Forensics & Hash Inspector:**
   - แสดงขนาด, ความละเอียดภาพ (Width × Height)
   - คำนวณค่า **MD5 Checksum** และ **SHA-256 Signature** สำหรับตรวจเช็คไฟล์ซ้ำบน Discord หรือฟอรั่มต่างๆ
   - ดึงข้อมูล **EXIF Metadata** เช่น รุ่นกล้อง, วันที่ถ่าย, ซอฟต์แวร์ที่ใช้ตัดต่อ
5. **Custom Keyword / Dork Filter:**
   - มีช่องสำหรับพิมพ์คำสำคัญเพิ่มเติม เช่น ชื่อคน, username, หรือสถานที่ เพื่อเพิ่มความแม่นยำในการเจาะหาบน Instagram และ Facebook

---

## 📁 โครงสร้างโฟลเดอร์ของโปรแกรม

```
OmniReverse-Desktop/
├── Launch-OmniReverse.bat        # ดับเบิลคลิกไฟล์นี้เพื่อเริ่มโปรแกรม
├── OmniReverse.ps1               # โค้ดหลักของโปรแกรม (WPF XAML Native GUI)
├── Create-Desktop-Shortcut.ps1   # สคริปต์สร้างทางลัดบน Desktop
├── README.md                     # คู่มือการใช้งานและคำอธิบายระบบ
└── assets/
    └── logo.jpg                  # ไอคอนและแบนเนอร์ของโปรแกรม
```
