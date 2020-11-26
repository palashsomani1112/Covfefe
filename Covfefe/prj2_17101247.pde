//#Covfefe - A processing based visual artwork based on tweets of Donald Trump

//Twitter API code reference taken from Jer Thorp's tutorial on blprnt.blg : http://blog.blprnt.com/blog/blprnt/updated-quick-tutorial-processing-twitter
//Drawing with image pixels reference taken from Daniel Shiffman's tutorial 10.7: Painting with pixels: https://www.youtube.com/watch?v=NbX3RnlAyGU

//The code makes a query request and retrieves all the tweets referring to Donald Trump using Twitter API with the help of 'twitter4j' library, 
//breaks those tweet strings into words and randomly place them over the screen where it takes the colour of the loaded image.

//There are 3 image modes which can be swithed using keyboard numeric keys: '1' = coloured Trump ; '2' = black stamp Trump ; '3' = greyscale Trump

//You can save the art images formed at anytime by pressing 's' key. They are saved inside the sketch folder.You can also see the framecount in the image's name when it was saved.
//Used minim library to play music in the background, just to make the artwork a little more interesting. Music taken from youtube : https://www.youtube.com/watch?v=zllLgWfNlX0

//A visual coding project by Palash Somani - Masters in Interactive Media (17101247) - Unversity of Limerick
//------------------------------------------------------------------------------------------------------------------
//libraries
import processing.pdf.*;
import twitter4j.conf.*;
import twitter4j.json.*;
import twitter4j.management.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import twitter4j.util.*;
import twitter4j.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
//------------------------------------------------------------------------------------------------------------------ 
//for clearScreen() function
color blackScreen = #000000;
color whiteScreen = #FFFFFF;
boolean AllBlack = false;

//builder
Minim minim;
AudioPlayer song;
FFT fft;
PImage img;
//Build an ArrayList to hold all of the words that we get from the imported tweets
ArrayList<String> words = new ArrayList();
//------------------------------------------------------------------------------------------------------------------ 
void setup() {
  //Set the size of the stage to fullscreen, and the background to white.
  fullScreen();
  frameRate(60);
  background(255);
  smooth();
  
  //Load the minim library
  minim = new Minim(this);
 
  //Load song
  song = minim.loadFile("trumpsong.mp3"); 
  
  //Create the FFT object to analyze the song
  fft = new FFT(song.bufferSize(), song.sampleRate());

  //Credentials for Twitter API
  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("4u6wEbmwZNM2SECRDLA5joQ6D");
  cb.setOAuthConsumerSecret("6bIt0pHjhZ8oAvTNj9E7GAOwoy1Mk3p5L7P8MeKUvRc5Ja55KF");
  cb.setOAuthAccessToken("211222136-oCvtKco0hYWt1MXoE9crJFvpyMZQ4pn2cK9SjrP8");
  cb.setOAuthAccessTokenSecret("Eh35dxwGfClq2u8eU8EnQlDEf4OmKsqJbAFa2IhG6Mb8P");
 
  //Make the twitter object and prepare the query realDonaldTrump
  Twitter twitter = new TwitterFactory(cb.build()).getInstance();
  Query query = new Query("#Covfefe");
  query.count(100);  //get the last 100 queries on Donald Trump
 
  //Try making the query request
  try {
    QueryResult result = twitter.search(query);
    ArrayList tweets = (ArrayList) result.getTweets();
 
    for (int i = 0; i < tweets.size(); i++) {
      Status t = (Status) tweets.get(i);
      String user = t.getUser().getScreenName();
      String msg = t.getText();
      println("Tweet by " + user + " at " + ": " + msg);
       
      //Break the tweet into words
      String[] input = msg.split(" ");
      for (int j = 0;  j < input.length; j++) {
       //Put each word into the words ArrayList
       words.add(input[j]);
      }
    };
  }
  catch (TwitterException te) {   //to deal with unwanted conditions like when no results are available or we aren't connected to the internet or Twitter API is down, hence the error.
    println("Couldn't connect: " + te);
  };
 //set desired image mode (default is coloured Trump mode)
 setImage(1);
 if (keyPressed == true){
    setImage(key);
 }
   song.play(0); //play song
   song.loop(); //loop song
}
//------------------------------------------------------------------------------------------------------------------  
void draw() {
  //Draw a word from the list of words that we've built
  int i = (frameCount % words.size());
  String word = words.get(i);
  float x = random(width);
  float y = random(height);
  color c = img.get(int(x),int(y)); //getting colour from the loaded image's pixels
  //Put it somewhere random on the stage, with a random size and colour of the image
  fill(c);
  textSize(random(5,10));
  text(word, x, y);
}
//------------------------------------------------------------------------------------------------------------------ 
//cases for switching image modes
void setImage(int image) {  
  switch(image) {
    case 1:
      img = loadImage("trump0.jpg");
      break;

    case 2:
      img = loadImage("trump1.jpg");
      break;

    case 3:
      img = loadImage("trump2.jpg");
      break;

  }
  
  img.resize(0, height);
  loadPixels();
}
//------------------------------------------------------------------------------------------------------------------ 
//saving the screen into an image file
String save() { 
  String filename = "covfefe.text." + frameCount + ".png";
  saveFrame(filename);
  println("saved as: " + filename);
  return filename;
}
//------------------------------------------------------------------------------------------------------------------ 
//cases for switching image modes with keypress and other key functions
void keyPressed() {

  switch(key) {

    case '1':
    clearScreen();
      setImage(1);
      break;

    case '2':
    clearScreen();
      setImage(2);
      break;

    case '3':
    clearScreen();
      setImage(3);
      break;
      
    case 's':
    save();
    break;
    
    case 'c':
    clearScreen();
    break;
  }
}
//------------------------------------------------------------------------------------------------------------------
//clear screen to white blank canvas
void clearScreen() {
  color screen = AllBlack ? blackScreen : whiteScreen;
  background(screen);
}
//-------------------------------------------------------END-------------------------------------------------------- 