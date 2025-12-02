# Gomoku (Five-in-a-Row) MATLAB Game

**Author:** Baowen Liu
**Course:** ENGR 1181.01 - The Ohio State University
**Date:** November 6, 2024

> **📄 Project Document:** [Click here to view Graphics_Preview.pdf](./Graphics_Preview.pdf)

## 📖 Introduction (简介)
This project is a MATLAB-based implementation of the traditional strategy board game **Gomoku** (Five-in-a-Row). Developed using the `simpleGameEngine`, this program features a graphical user interface (GUI) that allows players to interact with the game board using mouse inputs.

The game has been expanded from a simple board display to a fully functional game system with multiple levels, win detection, and an AI opponent.

## 🎮 Game Modes (游戏模式)
The game consists of three progressive levels:

* **Level 1: Three-in-a-row (9x9 Board)**
    * **Goal:** Connect **3** pieces horizontally, vertically, or diagonally.
    * **Opponent:** Player vs. Player (Hotseat).
* **Level 2: Five-in-a-row (15x15 Board)**
    * **Goal:** Connect **5** pieces (Standard Gomoku rules).
    * **Opponent:** Player vs. Player.
* **Level 3: Five-in-a-row with AI**
    * **Goal:** Connect **5** pieces.
    * **Opponent:** Player (Black) vs. AI (White).
    * **Features:** The AI is capable of blocking player wins and finding its own winning moves.

## ⚙️ Features (功能特性)
1.  **Interactive GUI:** Uses `simpleGameEngine` to render the board and sprites.
2.  **Turn-Based Logic:** Automatically switches turns between Black and White players.
3.  **Win Detection:** Algorithms to check for winning lines in all four directions (horizontal, vertical, and two diagonals).
4.  **AI Opponent:**
    * **Win Priority:** Checks if AI can win immediately.
    * **Block Priority:** Checks if the player is about to win and blocks them.
    * **Strategy:** Tries to extend existing lines if no immediate threats exist.
5.  **Visual Effects:** The winning pieces flash to highlight the victory condition.

## 🛠️ Requirements (运行环境)
To run this game, ensure the following files are in your MATLAB Current Folder:
* `wuzi_Final.m` (The main script)
* `simpleGameEngine.m` (The engine script)
* `Gomoku.png` (Sprite sheet)
* `Graphics_Preview.pdf` (Project documentation)

## 🚀 How to Play (如何游玩)
1.  Run the main script in MATLAB.
2.  Follow the instructions in the **Command Window** to see which level is currently active.
3.  **Black** moves first. Click on an empty intersection on the board to place your piece.
4.  The game will announce the winner or a draw in the Command Window and title bar.
5.  After a level is completed, the game proceeds to the next level automatically.

## 🧠 Algorithm Overview (算法概览)
* **`checkWin` Function:** Scans the board from the last played position to count consecutive pieces in all directions.
* **`aiMove` Function:**
    1.  Simulates moves to see if AI can win.
    2.  Simulates moves to see if the opponent will win, and blocks.
    3.  Heuristic search for strategic expansion.
    4.  Random fallback move.

---
*Created for the SDP Graphics Preview Assignment and Final Project.*
