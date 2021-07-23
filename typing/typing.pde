import ddf.minim.*;
Minim minim;
AudioSample misssound, sucsound, move;
final String default_script="typing";
PImage back; 
PImage cat;
PImage fish; 
PImage cat2;
int state=0;
String[] letters;
String letter;
int now=0; 
int time=1800; //<--new 時間
int missCount=0; //<--new ミスタイプ数
int cnt=0; //<--new 連続タイプ(10ごとに0になる)
boolean error=false; //<--new 間違えたかどうか
int errorCount=0; //<--new 間違い画像を表示する回数
int score=0; //<--new スコア
boolean continuous=false; //<--new 連続タイプができたかどうか
int continuousCount=0; //<--new タイム延長のテキストを表示する回数

//最初に呼ばれる関数
void setup() {
  size(900, 600, P3D); 
  back=loadImage("back.png"); 
  letters=loadStrings("script.csv");
  letters[0]=default_script;
  letter=letters[(int)random(letters.length)];
  textSize(50);
  textAlign(CENTER);
  PFont font = createFont("メイリオ", 50);  //<--new 日本語のフォントにする
  textFont(font);
  minim = new Minim( this );
  misssound = minim.loadSample( "cancel4.wav" );
  sucsound = minim.loadSample( "sucsound.wav" );
  move = minim.loadSample( "move.mp3" );
}

//1秒間に60回呼び出される関数
void draw() {
  switch(state) {
  case 0:
    frameCount=0;
    missCount=0;
    score=0;
    cnt=0;
    error=false;
    time=1800;
    image(back, 0, 0);
    fill(255);
    text("push space", width/2, height/2);
    break;
  case 1:
    image(back, 0, 0);
    fill(0, 255/3, 255, 100);
    rect(frameCount*5-100, 0, 30, height);

    if (error) {//<--new ミスタイプをしたら呼び出される。
      fill(255, 0, 0, 100);
      rect(0, 0, width, height);
      errorCount++; //<--new この部分が呼び出される回数を数える
      if (errorCount>=30) { //<--new 0.5秒間画像を表示する
        error=false; //<--new ミスはなかったことに...
        errorCount=0; //<--new 回数は0に戻しておきましょう
      }
    } 

    fill(255, 255, 255);
    text(letter, 450, 200);
    text("now : "+letter.charAt(now), 450, 260);

    // 残り時間を四角形で表示する
    fill(255/4, 255/2, 255/3, 255); //<--new 色を設定
    noStroke(); //<--new 縁の色はなしにする
    rect(0, 0, time/2, 20); //<--new 四角形を書く命令

    if (continuous) {
      fill(0, 212, 166); //<--new テキスト色の変更
      text("PLUS", 800, 80); //<--new テキストを表示
      continuousCount++; //<--new 何回表示されたかを記録
      if (continuousCount>=50) { //<--new PLUSを表示するのは50回まで！
        continuousCount=0; //<--new 回数を0に戻す
        continuous=false; //<--new 呼び出されなくする
      }
    }

    if (frameCount>=180) {
      letter=letters[(int)random(letters.length)]; 
      now=0; 
      frameCount=0;
    }
    time--; //<--new 残り時間を減らす

    if (time<=0) {//<--new タイムが0になったら
      state++;
      move.trigger();
    }
    break;
  case 2:
    image(back, 0, 0);
    fill(255, 255, 255); //<--new テキストの色を白にする
    text("SCORE:"+score+"  ミスタイプ数 :"+missCount, 450, 200); //<--new結果のテキストを表示する
    break;
  default:
    break;
  }
}

//キーボードが押されたら呼ばれる関数
void keyPressed() {
  switch(state) {
  case 1:
    char s=letter.charAt(now);
    if (equal_updown(key, s)) {
      cnt++; //<--new 連続タイプ数を増やす
      score++; //<--new スコアを増やす
      now++;
      if (now==letter.length()) {
        letter=letters[(int)random(letters.length)];   
        now=0; 
        frameCount=0;
      }
      if (cnt>=10) { //<--new 連続タイプが10以上になると
        cnt=0;
        time+=60; //<--new タイムが1秒増える
        continuous=true; //<--new 連続タイプできたことを伝える
      }
      sucsound.trigger();
    } else { //<--new ミス
      missCount++; //<--new ミスタイプを数える
      cnt=0; //<--new ミスすると連続タイプ数が0に戻る
      error=true; //<--new 間違えたことを伝える
      misssound.trigger();
    }
    break;
  case 0:
    if (key==ENTER||key==' ') {
      state=1;
    }
    break;
  case 2:
    if (key==ENTER||key==' ') {
      state=0;
    }
    break;
  }
}

boolean equal_updown(char a, char b) {
  if (a==b||a==(b&0x5f)||a==(b|0x20)) {
    return true;
  } else {
    return false;
  }
}

void stop() {
  misssound.close();
  sucsound.close();

  minim.stop();

  super.stop();
}
