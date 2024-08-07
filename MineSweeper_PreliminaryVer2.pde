//=========================================================================================================================
// 親の絶対クラス(Minesweeper)
abstract class Minesweeper {
  int w, row, col;
  boolean isClicked = false;
  boolean flag = false;
  // コンストラクタ
  Minesweeper(int row0, int col0, int w0) {
    row = row0;
    col = col0;
    w = w0;
  }
  // セルの表示
  abstract void displayCell();
  // マウスがマスに含まれているかどうか
  boolean contain() {
    if (mouseX <= row*w+w && mouseX >= row*w && mouseY <= col*w+w+100 && mouseY >= col*w+100) {
      return true;
    }
    return false;
  }
  abstract void neghOpen(Minesweeper[][] cells);
  abstract int countAroundMine(Minesweeper[][] cells);
}
//---------------------------------------------------------------------------------------------------------------------------
// 爆弾があるセル(Minesweeper サブクラス1)
class Bomb extends Minesweeper {
  // コンストラクタ
  Bomb(int row0, int col0, int w0) {
    super(row0, col0, w0);
  }
  // セルの表示
  void displayCell() {
    if (!flag) {
      if (isClicked) {
        ui.displayBomb(row, col, w);
      } else {
        fill(125, 125, 125);
        rect(row*w, col*w+100, w, w);
      }
    }
  }

  void neghOpen(Minesweeper[][] cells) {
    //do nothing
  }
  int countAroundMine(Minesweeper[][] cells) {
    return 0;
  }
}
//---------------------------------------------------------------------------------------------------------------------------
// 爆弾がないセル(Minesweeper サブクラス2)
class NotBomb extends Minesweeper {
  // コンストラクタ
  NotBomb(int row0, int col0, int w0) {
    super(row0, col0, w0);
  }
  // セルの表示
  void displayCell() {
    strokeWeight(1);
    if (!flag) {
      if (isClicked) {
        fill(255, 255, 255);
        rect(row*w, col*w+100, w, w);
        displayMineNum(cells);
      } else {
        fill(125, 125, 125);
        rect(row*w, col*w+100, w, w);
      }
    }
  }
  // 自身のセルの周りの爆弾の数を表示
  void displayMineNum(Minesweeper[][] cells) {
    int count = countAroundMine(cells);
    if (count != 0) {
      fill(255, 0, 0);
      textSize(16);
      text(count, row*w+w/3, col*w+w/2+100);
    }
  }
  // 自身のセルの周りの爆弾を数える
  int countAroundMine(Minesweeper[][] cells) {
    int count = 0;
    //現在のセルの位置が...
    if (row == 0 && col == 0) {
      return countRowZeroColZero(cells); // 左上の角のセル
    } else if (row == 0 && col == cells[0].length - 1) {
      return countRowZeroColMax(cells); // 左下の角のセル
    } else if (row == cells.length - 1 && col == 0) {
      return countRowMaxColZero(cells); // 右上の角のセル
    } else if (row == cells.length - 1 && col == cells[0].length - 1) {
      return countRowMaxColMax(cells); // 右下の角のセル
    } else if (row == 0) {
      return countRowZero(cells); // 一番左のセル
    } else if (row == cells.length - 1) {
      return countRowMax(cells); // 一番右のセル
    } else if (col == 0) {
      return countColZero(cells); // 一番上のセル
    } else if (col == cells.length - 1) {
      return countColMax(cells); // 一番下のセル
    } else { // それ以外のセル
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (cells[row - 1 + i][col - 1 + j] instanceof Bomb) {
            count++;
          }
        }
      }
      return count;
    }
  }
  // cells[0][0]の爆弾の数を数える
  int countRowZeroColZero(Minesweeper[][] cells) {
    int count = 0;
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        if (cells[row + i][col + j] instanceof Bomb) {
          count++;
        }
      }
    }
    return count;
  }
  // cells[0][max]の爆弾の数を数える
  int countRowZeroColMax(Minesweeper[][] cells) {
    int count = 0;
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        if (cells[row + i][col - 1 + j] instanceof Bomb) {
          count++;
        }
      }
    }
    return count;
  }
  // cells[max][0]の爆弾の数を数える
  int countRowMaxColZero(Minesweeper[][] cells) {
    int count = 0;
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        if (cells[row - 1 + i][col + j] instanceof Bomb) {
          count++;
        }
      }
    }
    return count;
  }
  // cells[max][max]の爆弾の数を数える
  int countRowMaxColMax(Minesweeper[][] cells) {
    int count = 0;
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        if (cells[row - 1 + i][col - 1 + j] instanceof Bomb) {
          count++;
        }
      }
    }
    return count;
  }
  // cells[0][~]の爆弾の数を数える
  int countRowZero(Minesweeper[][] cells) {
    int count = 0;
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 3; j++) {
        if (cells[row + i][col - 1 + j] instanceof Bomb) {
          count++;
        }
      }
    }
    return count;
  }
  // cells[max][~]の爆弾の数を数える
  int countRowMax(Minesweeper[][] cells) {
    int count = 0;
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 3; j++) {
        if (cells[row - 1 + i][col - 1 + j] instanceof Bomb) {
          count++;
        }
      }
    }
    return count;
  }
  // cells[~][0]の爆弾の数を数える
  int countColZero(Minesweeper[][] cells) {
    int count = 0;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 2; j++) {
        if (cells[row - 1 + i][col + j] instanceof Bomb) {
          count++;
        }
      }
    }
    return count;
  }
  // cells[~][max]の爆弾の数を数える
  int countColMax(Minesweeper[][] cells) {
    int count = 0;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 2; j++) {
        if (cells[row - 1 + i][col - 1 + j] instanceof Bomb) {
          count++;
        }
      }
    }
    return count;
  }
  //自身の周りに爆弾が無い時に隣接するマスを開く
  void neghOpen(Minesweeper[][] cells) {
    if (countAroundMine(cells) == 0) {
      for (int i=0; i<3; i++) {
        int row2 = row-1+i;
        if (row2 < 0 || row2 >= rows) {
          row2=row;
        }
        for (int j=0; j<3; j++) {
          int col2 = col-1+j;
          if (col2 < 0 || col2 >= cols) {
            col2=col;
          }
          cells[row2][col2].isClicked = true;
        }
      }
    }
  }
}
//=========================================================================================================================
// 画面を表示する親クラス（絶対クラス Screen）
abstract class Screen {
  boolean judCurPos;
  Minesweeper[][] cells = new Minesweeper[rows][cols];
  // コンストラクタ
  Screen(Minesweeper[][] cells0, boolean judFirPos) {
    cells = cells0;
    judCurPos = judFirPos;
  }
  abstract void display();
}
//-------------------------------------------------------------------------------------------------------------------------
// スタート画面(Screen サブクラス1)
class startScreen extends Screen {
  boolean isEasy = false;
  boolean isNormal = true;
  boolean isHard = false;
  // コンストラクタ
  startScreen(Minesweeper[][] cells0, boolean judFir) {
    super(cells0, judFir);
  }
  void display() {
    background(0);
    // メッセージ1
    fill(255, 0, 0);
    textSize(width/8);
    text("Minesweeper", width/8, height/5);
    // メッセージ2
    textSize(width / 15);
    text("Click Select Mode", width/4, height * 2/5);
    // メッセージ3
    fill(255, 0, 0);
    text("Easy", width/6, height * 2/4);
    ui.displaySelectCir(width/4, height * 3/5, isEasy); //EasyUI <<<<<<修正箇所
    // メッセ―ジ4
    fill(255, 0, 0);
    text("Normal", width * 3/8, height * 2/4);
    ui.displaySelectCir(width * 2/4, height * 3/5, isNormal); //NormalUI <<<<<<修正箇所
    // メッセージ5
    fill(255, 0, 0);
    text("Hard", width * 4/6, height * 2/4);
    ui.displaySelectCir(width * 3/4, height * 3/5, isHard); //HardUI <<<<<<修正箇所
    // 円をクリックしたときの処理
    clickedCircle();
    // メッセージ6
    fill(255, 0, 0);
    textSize(width / 15);
    text("Start Press SPACE!!", width/4, height * 4/5);
  }
  // 円をクリックしたときの処理
  void clickedCircle() {
    if (mouseButton == LEFT) {
      if (dist(mouseX, mouseY, width/4, height * 3/5) <= width / 10) {
        isEasy = true;
        isNormal = false;
        isHard = false;
      } else if (dist(mouseX, mouseY, width * 2/4, height * 3/5) <= width / 10) {
        isEasy = false;
        isNormal = true;
        isHard = false;
      } else if (dist(mouseX, mouseY, width * 3/4, height * 3/5) <= width / 10) {
        isEasy = false;
        isNormal = false;
        isHard = true;
      }
    }
  }
}
//-------------------------------------------------------------------------------------------------------------------------
// プレイ画面(Screen サブクラス2)
class playScreen extends Screen {
  // コンストラクタ
  playScreen(Minesweeper[][] cells0, boolean judFir) {
    super(cells0, judFir);
  }
  void display() {
    background(255);
    ui.displayScore(width/11, height/10);
    //ホームキーの表示
    if (!startClicked) {
      fill(255, 0, 0);
      textSize(30);
      text("Home Press E", width/3, height/10);
    }
    ui.displayBombCount(width-width/6, height/11);
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        cells[i][j].displayCell();
        if (cells[i][j].flag == true) {
          ui.displayFlag(cells[i][j].row, cells[i][j].col, cells[i][j].w);
        }
        if (cells[i][j].isClicked == true && cells[i][j].countAroundMine(cells) == 0) {
          cells[i][j].neghOpen(cells);
        }
      }
    }
  }
}
//-------------------------------------------------------------------------------------------------------------------------
// ゲームオーバー画面(Screen サブクラス3)
class endScreen extends Screen {
  // コンストラクタ
  endScreen(Minesweeper[][] cells0, boolean judFir) {
    super(cells0, judFir);
  }
  void display() {
    // 爆弾を全て表示
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (cells[i][j] instanceof Bomb) {
          cells[i][j].isClicked = true;
        }
        cells[i][j].displayCell();
      }
    }
    fill(0, 255, 0);
    // メッセージ1
    textSize(width / 10);
    text("Do not mind!!", width/4, height/2);
    // メッセージ2
    textSize(width / 15);
    text("Retry Press SPACE!!", width/4, height*3/4);
  }
}
//-------------------------------------------------------------------------------------------------------------------------
// クリア画面(Screen サブクラス4)
class clearScreen extends Screen {
  // コンストラクタ
  clearScreen(Minesweeper[][] cells0, boolean judFir) {
    super(cells0, judFir);
  }
  void display() {
    // メッセージ1
    fill(0, 0, 255);
    textSize(width / 10);
    text("Clear Congratulation!!", width/20, height/2);
    textSize(width / 15);
    text("Home Press SPACE", width/4, height*3/4);
  }
}
//-------------------------------------------------------------------------------------------------------------------------
//爆弾の数などのUIのクラス
class UserInterface {
  private int baseTime = 0;
  // 爆弾を表示
  void displayBomb(int x0, int y0, int w) {
    int x=x0*w+w*4/7;
    int y=y0*w+w*4/7+100;
    strokeWeight(1);
    fill(0);
    ellipse(x, y, w*1/3, w*1/3);
    strokeWeight(3);
    for (int i=0; i<8; i++) {
      line(x, y, x+w/3*sin(PI/4*i), y+w/3*cos(PI/4*i));
    }
  }
  // 画面上部に爆弾の数を表示
  void displayBombCount(int x, int y) {
    fill(0);
    strokeWeight(1);
    line(x+42, y+5, x+52, y-5);
    line(x+42, y-5, x+52, y+5);
    textSize(30);
    text("Bomb", x-40, y+10);
    text(BombCount, x+60, y+10);
  }
  // 旗の表示
  void displayFlag(int row, int col, int w) {
    fill(255, 0, 0);
    triangle(row*w+w/3, col*w+w/4+100, row*w+2*w/3, col*w+w/3+100, row*w+w/3, col*w+w/2+100);
    strokeWeight(3);
    line(row*w+w/3, col*w+w/4+100, row*w+w/3, col*w+w+100);
    strokeWeight(1);
  }
  // Scoreの表示
  void displayScore(int x, int y) {
    int time = (millis() - baseTime)/1000;
    if (!startClicked) {
      baseTime = millis();
    }
    fill(0);
    textSize(35);
    text("Score:"+time, x, y);
  }
  // 難易度選択の円の表示 <<<<<<修正箇所
  void displaySelectCir(int x, int y, boolean isClicked) {
    if (isClicked) {
      fill(255, 0, 0);
    } else {
      fill(255);
    }
    ellipse(x, y, width/10, height/10);
  }
}
//=========================================================================================================================
int rows = 15; // 行数
int cols = 15; // 列数
int BombCount; //爆弾の数
int CellsCount = rows * cols;
int FlagCount = 0;
boolean startClicked = false; // 最初のセルをクリックしたかどうか
Minesweeper[][] cells = new Minesweeper[rows][cols];
startScreen start;
endScreen end;
playScreen play;
clearScreen clear;
UserInterface ui;

void setup() {
  size(600, 700);
  int w = width / rows;
  // 始めのセルは全てNot爆弾のクラスで設定
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      cells[i][j] = new NotBomb(i, j, w);
    }
  }
  ui = new UserInterface();
  start = new startScreen(cells, true);
  play = new playScreen(cells, false);
  end = new endScreen(cells, false);
  clear = new clearScreen(cells, false);
}

void draw() {
  // スタート画面を表示する
  if (start.judCurPos) {
    start.display();
  }
  // プレイ画面を表示する
  if (play.judCurPos) {
    play.display();
    if (isClickedBomb(cells)) { // 爆弾を押したとき
      play.judCurPos = false;
      end.judCurPos = true;
    }
    if (isClickedAllCells(cells)) { // 爆弾以外の全てのセルを押したとき
      play.judCurPos = false;
      clear.judCurPos = true;
    }
  }
  // ゲームオーバー画面を表示する
  if (end.judCurPos) {
    end.display();
  }
  // クリア画面を表示する
  if (clear.judCurPos) {
    clear.display();
  }
}

// 爆弾が押されたかどうか
boolean isClickedBomb(Minesweeper[][] cells) {
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      if (cells[i][j] instanceof Bomb && cells[i][j].isClicked == true) {
        return true;
      }
    }
  }
  return false;
}

// 爆弾以外のセルを全て押したかどうか <<<<<<修正箇所
boolean isClickedAllCells(Minesweeper[][] cells) {
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      if (cells[i][j] instanceof NotBomb && cells[i][j].isClicked == false) {
        return false;
      }
    }
  }
  return true;
}

// ゲームをリセットする
void resetGame() {
  int w = width / rows;
  BombCount = 0;
  FlagCount = 0;
  // setup関数と同様に全てを普通のセルで初期化
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      cells[i][j] = new NotBomb(i, j, w);
    }
  }
  // 最初のクリックを初期化
  startClicked = false;
}

// 始めの一回目が押されたときにランダムに爆弾を設置
void setupMinesweeper(int startRow, int startCol) {
  int w = width / rows;
  int rand;
  int count = 0;
  if (start.isEasy) {
    BombCount = 10;
  } else if (start.isNormal) {
    BombCount = 30;
  } else if (start.isHard) {
    BombCount = 40;
  }
  // 爆弾の設置
  while (count < BombCount) {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        //初めにクリックしたセルの周りに爆弾を生成しないための条件
        if (i == startRow && j == startCol || i == startRow-1 && j == startCol || i == startRow-1 && j == startCol+1
          || i == startRow && j == startCol+1 || i == startRow+1 && j == startCol+1 || i == startRow+1 && j == startCol
          || i == startRow+1 && j == startCol-1 || i == startRow && j == startCol-1 || i == startRow-1 && j == startCol-1) {
          continue;
        }
        rand = int(random(1, 10));
        if (rand == 1 && cells[i][j] instanceof Bomb == false && count < BombCount) {
          cells[i][j] = new Bomb(i, j, w);
          count++;
        }
      }
    }
  }
}

void mousePressed() {
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      if (cells[i][j].contain()) {
        if (play.judCurPos && mouseButton == LEFT && !cells[i][j].flag) {
          if (!startClicked) { // 始めの一回目が押されたとき
            startClicked = true;
            setupMinesweeper(i, j);
          }
          cells[i][j].isClicked = true;
        }
        //旗の設置、除去
        if (startClicked && mouseButton == RIGHT) {
          if (cells[i][j].flag) {
            cells[i][j].flag = false;
            FlagCount--;
          } else {
            cells[i][j].flag = true;
            FlagCount++;
          }
        }
      }
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    if (start.judCurPos) {
      start.judCurPos = false;
      play.judCurPos = true;
    } else if (end.judCurPos) {
      end.judCurPos = false;
      play.judCurPos = true;
      resetGame();
    } else if (clear.judCurPos) {
      clear.judCurPos = false;
      start.judCurPos = true;
      resetGame();
    }
  }
  if (key == 'e') {
    if (play.judCurPos) {
      play.judCurPos = false;
      start.judCurPos = true;
      resetGame();
    }
  }
}
