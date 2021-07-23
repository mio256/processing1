import ddf.minim.*;

Minim minim;
AudioSample punch;

void setup() {
  size( 300, 200 );
  minim = new Minim( this );

  punch = minim.loadSample( "nc174845.mp3" );
}

void draw() {
}

void keyPressed()
{
  if ( key == 'p' )
  {
    punch.trigger();
  }
}

void stop() {
  punch.close();

  minim.stop();

  super.stop();
}
      
