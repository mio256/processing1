import processing.net.*;
PImage img;

int port = 10001; // 適当なポート番号を設定

Server server;

int x_pos=20;
int y_pos=20;

void setup() {
  size(500, 500);
  server = new Server(this, port);
  //println("server address: " + server.ip()); // IPアドレスを出力
  //set foreground
  surface.setAlwaysOnTop(true);
  //resize
  surface.setResizable( true );
}

void draw() {
  Client client = server.available();
  if (client !=null) {
    String whatClientSaid = client.readString();
    if (whatClientSaid != null) {
      println(whatClientSaid); // Pythonからのメッセージを出力
      String dst_path=whatClientSaid;
      img = loadImage(dst_path);
      img.resize(0, height);
      background(255);
      imageMode(CENTER);
      image(img, width/2, height/2);
    }
  }
}
