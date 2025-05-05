# 🧠 ahk-vim-navigation.ahk

**Because your mouse is a liar and the keyboard is your Excalibur.**

> _"In the beginning, the Universe was created. This has made a lot of people very angry and been widely regarded as a bad move. So was using the mouse to scroll through text when you could be using VIM-mode."_

## 📦 What is this?

This is a **keyboard navigation enhancement script** using [AutoHotKey v1](https://www.autohotkey.com/). It lets you turn your entire computer into a snarky text editor from 1991 — but sexier.

The goal: **use your keyboard like a boss** to move around and edit text with frightening speed and precision.

> Think: you press `j`, and your cursor goes down. You press `h`, and it moonwalks to the left. You press `Ctrl` twice, and BAM — you're in VIM-mode, baby. There's no going back.

## 🧙‍♂️ Background for Non-VIM-mortals

Vim is a text editor used by developers, sysadmins, and the occasional sorcerer. It has modes. Yes, _modes_. Like a moody teenager, Vim behaves differently depending on how you interact with it.

This script brings those mystical modes to Windows. Sort of like importing sushi to a medieval banquet. It doesn’t quite fit, but it’s delicious and slightly dangerous.

## 🚀 Installation (Read: Ritual Summoning)

1. Install [AutoHotKey v1.1](https://www.autohotkey.com/download/).
2. Download `ahk-vim-navigation.ahk`.
3. Put it in your `Startup` folder so it launches every time your machine awakens from its silicon slumber:
   ```ahk
   FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\%A_ScriptName%.lnk, %A_ScriptDir%
   ```
4. Run the script.
5. **Double tap `Esc` or `Ctrl` to enter VIM-mode.**

---

# 🕹️ VIM-Mode Hotkeys

## 🧨 Activating VIM-mode

| Action            | How                          | Result                                                                                                               |
| ----------------- | ---------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| Activate VIM-mode | Double press `Esc` OR `Ctrl` | You will enter “VIM-mode”. A glorious black box will appear saying “VI-NORMAL”. You’ve now left the land of mortals. |
| Exit VIM-mode     | Press `Esc`, `Ctrl`, or `i`  | Return to your regularly scheduled Windows experience.                                                               |

---

## 🏃 Cursor Movement (Arrow keys are for cowards)

| Key | What it does | Description                |
| --- | ------------ | -------------------------- |
| `h` | ← Left       | Like a crab, scuttle left. |
| `j` | ↓ Down       | Jump down one line.        |
| `k` | ↑ Up         | Kick upward a line.        |
| `l` | → Right      | Lurch to the right.        |

> Pro tip: Add a number before the movement. `5j` goes down 5 lines like a caffeinated frog.

---

## 🧭 Page Movement

| Key        | What it does                 |
| ---------- | ---------------------------- |
| `w`        | Jump forward a word (Ctrl+→) |
| `b`        | Jump back a word (Ctrl+←)    |
| `0`        | Go to beginning of line      |
| `-` or `$` | Go up one line               |
| `x`        | Delete character (🔪)        |

---

## ✨ Editing Magic

| Key       | Action                             |
| --------- | ---------------------------------- |
| `i`       | Go to insert mode (exits VIM-mode) |
| `Shift+i` | Go to beginning of line and insert |
| `a`       | Move right and insert              |
| `Shift+a` | Go to end of line and insert       |
| `.`       | Repeat last command                |
| `>`       | Indent line                        |
| `<`       | Outdent line                       |
| `d`       | Delete (Ctrl+X, basically a cut)   |
| `y`       | Copy                               |
| `p`       | Paste                              |
| `u`       | Undo (Ctrl+Z)                      |
| `/`       | Search (Ctrl+F)                    |

---

## 🦾 Selection Mode (Like cursor movement but juiced with Shift)

| Key       | What it selects                 |
| --------- | ------------------------------- |
| `Shift+h` | Select left                     |
| `Shift+l` | Select right                    |
| `Shift+j` | Select down                     |
| `Shift+k` | Select up                       |
| `Shift+w` | Select next word                |
| `Shift+b` | Select previous word            |
| `)`       | Select to beginning of line     |
| `_`       | Select to end of line           |
| `Shift+x` | Delete (Ctrl+X / cut) selection |

---

## 🔢 Numbers!

| Keys       | Use                                                                |
| ---------- | ------------------------------------------------------------------ |
| `1-9`, `0` | Prefix a number before a movement (like `3j` to move down 3 lines) |

Note: if you enter a number that is too ridiculous (above 500), it gets reset to something sane. This is for your safety, and your ego.

---

## 🛸 Bonus Mode: **Spacebar Navigation**

> For those times when your fingers are just resting near the spacebar and you think, “Gee, what if the spacebar could be my command center?”

Hold `Space`, then press:

| Key                | Action                            |
| ------------------ | --------------------------------- |
| `h`, `j`, `k`, `l` | Move like Vim                     |
| `w`, `b`           | Page-word movement                |
| `x`, `0`, `-`, `$` | Delete, home, end, end            |
| `u`                | Undo                              |
| `i`                | Rename file (F2) — yep, it’s wild |

---

# 🧹 Techy Internals

- The script uses `inputNumber` to store how many times you want a thing done (e.g., `5j` = down 5 lines).
- `lastCommand` stores the last operation so you can repeat it with a `.`
- GUI popups appear to remind you what’s happening. You will never be alone again.

---

## Extras

### 📦 Navigation (Vim-style, but ALT is your buddy)

| Combo     | Action       | Description                 |
| --------- | ------------ | --------------------------- |
| `Alt + h` | ← Left       | Just like `h` in Vim        |
| `Alt + j` | ↓ Down       | Just like `j` in Vim        |
| `Alt + k` | ↑ Up         | Just like `k` in Vim        |
| `Alt + l` | → Right      | Just like `l` in Vim        |
| `Alt + w` | → Word       | Move forward by word        |
| `Alt + b` | ← Word       | Move back by word           |
| `Alt + 0` | ⬅ Line Start | Go to beginning of the line |
| `Alt + $` | ➡ Line End   | Go to end of the line       |
| `Alt + u` | ⬆ Document   | Go to beginning of document |
| `Alt + o` | ⬇ Document   | Go to end of document       |

### 🔥 Word-by-word Navigation (ALT + CTRL)

| Combo            | Action             |
| ---------------- | ------------------ |
| `Ctrl + Alt + w` | Move forward word  |
| `Ctrl + Alt + b` | Move backward word |

### 🎯 Selecting Stuff (with SHIFT)

| Combo             | Action                          |
| ----------------- | ------------------------------- |
| `Shift + Alt + h` | Select character to the left    |
| `Shift + Alt + j` | Select line below               |
| `Shift + Alt + k` | Select line above               |
| `Shift + Alt + l` | Select character to the right   |
| `Shift + Alt + w` | Select next word                |
| `Shift + Alt + b` | Select previous word            |
| `Shift + Alt + 0` | Select to beginning of line     |
| `Shift + Alt + $` | Select to end of line           |
| `Shift + Alt + u` | Select to beginning of document |
| `Shift + Alt + o` | Select to end of document       |

### 🧙‍♂️ Bonus Combos

| Combo             | Action                                                   |
| ----------------- | -------------------------------------------------------- |
| `Ctrl + Alt + E`  | Launch\* [Everything Search](https://www.voidtools.com/) |
| `CapsLock`        | Acts like `Backspace` (say goodbye to bad habits)        |
| `Ctrl + CapsLock` | Acts like regular `CapsLock`                             |
| `Backspace`       | Now acts like `CapsLock`                                 |

---

## 🎧 Special Modes

> I don't have a right `Control` key in my keyboard !

- **F3 in VSCode** launches _Zen Mode_ with `Ctrl + K, Z`. Instant minimalism. 🧘
- **AltGr fix**: When active in any window, `AltGr` becomes regular `Alt`. Helpful for typing special characters or fixing layout bugs.

---

# 🪄 Philosophy

This script was born from the idea that **you should not have to use your mouse like some kind of digital rodent herder**. Instead, ride the lightning of keyboard-driven navigation.

Use it. Learn it. Become it. Soon, you’ll look at other people dragging windows and scrolling with scroll wheels and whisper, “Oh, you sweet summer child.”

---

# 🧠 Credits

- Original script by Jongbin Jung
- Inspired by Model_Vim.ahk by Rich Alesi
- Adapted for modern AHK by Andrej Mitrovic
- README written under heavy influence from caffeine and [**_The Hitchhiker’s Guide to the Galaxy_**](https://www.amazon.com/Hitchhikers-Guide-Galaxy-Douglas-Adams-ebook/dp/B000XUBC2C/ref=tmm_kin_swatch_0?_encoding=UTF8&dib_tag=se&dib=eyJ2IjoiMSJ9.id52f0YUeOh-GAio4HESmqpM0LfaYvovTl_4RlXLHkowV7kLCWpJrdeplhse1nXMATixIGY78l456bvZsaVWNyEAMRFEg-9bvlrBpB0Da9MctE7QxpK_j38hksoM2q4Ps5QW_i2mKL1xYTwEWCiHOLn9pHjp2c4T9ylMXzo2oSlYr61Oi5erkks7atWsjaNTVxOkpoxz-ay2-pAuIDuGYaD4DJF4Np840Ue9nBT0BGY.Rc4jdMjUMoyg6En6QQGVGDF2fr50aJHyshPlWUUYdO8&qid=1712870820&sr=8-1)

---

# 🛸 Final Thoughts

> _"So long and thanks for all the `h`, `j`, `k`, `l`."_

You’re not just using Windows anymore. You’re navigating it at warp speed. Welcome to the Keyboard Cult™.

---
