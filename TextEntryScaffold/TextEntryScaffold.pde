import java.util.Arrays;
import java.util.Collections;
import java.util.Random;

String[] phrases; //contains all of the phrases
int totalTrialNum = 2; //the total number of phrases to be tested - set this low for testing. Might be ~10 for the real bakeoff!
int currTrialNum = 0; // the current trial number (indexes into trials array above)
float startTime = 0; // time starts when the first letter is entered
float finishTime = 0; // records the time of when the final trial ends
float lastTime = 0; //the timestamp of when the last trial was completed
float lettersEnteredTotal = 0; //a running total of the number of letters the user has entered (need this for final WPM computation)
float lettersExpectedTotal = 0; //a running total of the number of letters expected (correct phrases)
float errorsTotal = 0; //a running total of the number of errors (when hitting next)
String currentPhrase = ""; //the current target phrase
String currentTyped = ""; //what the user has typed so far
String[] values;
int lastClick;
int counter;
final int DPIofYourDeviceScreen = 200; //look up the DPI or PPI of your device to make sure you get the right scale
//http://en.wikipedia.org/wiki/List_of_displays_by_pixel_density
final float sizeOfInputArea = DPIofYourDeviceScreen*1; //aka, 1.0 inches square!
PImage watch;

//Variables for my silly implementation. You can delete this:
char currentLetter = 'a';

//You can modify anything in here. This is just a basic implementation.
void setup()
{
  watch = loadImage("watchhand3smaller.png");
  phrases = loadStrings("phrases2.txt"); //load the phrase set into memory
  setValues();
  Collections.shuffle(Arrays.asList(phrases), new Random()); //randomize the order of the phrases with no seed
  //Collections.shuffle(Arrays.asList(phrases), new Random(100)); //randomize the order of the phrases with seed 100; same order every time, useful for testing
 
  orientation(LANDSCAPE); //can also be PORTRAIT - sets orientation on android device
  size(800, 800); //Sets the size of the app. You should modify this to your device's native size. Many phones today are 1080 wide by 1920 tall.
  textFont(createFont("Arial", 24)); //set the font to arial 24. Creating fonts is expensive, so make difference sizes once in setup, not draw
  noStroke(); //my code doesn't use any strokes
}

void setValues() {
  lastClick = -1;
  counter = -1;
  values = new String[9];
  values[0] = "abc";
  values[1] = "def";
  values[2] = "ghi";
  values[3] = "jkl";
  values[4] = "mno";
  values[5] = "pqrs";
  values[6] = "tuv";
  values[7] = "wxyz";
  values[8] = "_";
}

//You can modify anything in here. This is just a basic implementation.
void draw()
{
  background(255); //clear background
  drawWatch(); //draw watch background
  fill(100);
  stroke(100);
  rect(width/2-sizeOfInputArea/2, height/2-sizeOfInputArea/2, sizeOfInputArea, sizeOfInputArea); //input area should be 1" by 1"

  if (finishTime!=0)
  {
    fill(128);
    text("Finished", 280, 150);
    return;
  }

  if (startTime==0 & !mousePressed)
  {
    fill(128);
    textAlign(CENTER);
    text("Click to start time!", 280, 150); //display this messsage until the user clicks!
  }

  if (startTime==0 & mousePressed)
  {
    nextTrial(); //start the trials!
  }

  if (startTime!=0)
  {
    //feel free to change the size of the target/entered phrases and next button 
    textAlign(LEFT); //align the text left
    fill(128);
    text("Phrase " + (currTrialNum+1) + " of " + totalTrialNum, 70, 50); //draw the trial count
    fill(128);
    text("Target:   " + currentPhrase, 70, 100); //draw the target string
    text("Entered:  " + currentTyped +"|", 70, 140); //draw what the user has entered thus far 

    //draw very basic next button
    fill(255, 0, 0);
    rect(600, 600, 200, 200);
    fill(255);
    text("NEXT > ", 650, 650);

    // Draw letterpad
    fill(255, 255, 255);
    stroke(0, 0, 0);
    rect(width/3-sizeOfInputArea/3+(2*sizeOfInputArea)/4, height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2 +sizeOfInputArea/5, sizeOfInputArea/3, sizeOfInputArea/4);
    textAlign(CENTER);
    fill(0, 0, 0);
    text("abc", (width/3-sizeOfInputArea/3+(2*sizeOfInputArea)/4)+(1.5/3*sizeOfInputArea/3), height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2+(1.8*sizeOfInputArea/5));
    
    fill(255, 255, 255);
    rect(width/3-sizeOfInputArea/4+(3*sizeOfInputArea)/4, height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2 +sizeOfInputArea/5, sizeOfInputArea/3, sizeOfInputArea/4); 
    textAlign(CENTER);
    fill(0, 0, 0);
    text("def", (width/3-sizeOfInputArea/3+(2*sizeOfInputArea)/4)+(1.5*sizeOfInputArea/3), height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2+(1.8*sizeOfInputArea/5));
    
    fill(255, 255, 255);
    rect(width/3-sizeOfInputArea/4+(4.35*sizeOfInputArea)/4, height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2 +sizeOfInputArea/5, sizeOfInputArea/3, sizeOfInputArea/4);
    textAlign(CENTER);
    fill(0, 0, 0);
    text("ghi", (width/3-sizeOfInputArea/3+(2*sizeOfInputArea)/4)+(2.5*sizeOfInputArea/3), height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2+(1.8*sizeOfInputArea/5));

    // second row
    fill(255, 255, 255);
    rect(width/3-sizeOfInputArea/3+(2*sizeOfInputArea)/4, sizeOfInputArea/4+height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2 +sizeOfInputArea/5, sizeOfInputArea/3, sizeOfInputArea/4); //draw left red button
    textAlign(CENTER);
    fill(0, 0, 0);
    text("jkl", (width/3-sizeOfInputArea/3+(2*sizeOfInputArea)/4)+(1.5/3*sizeOfInputArea/3), height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2+(3*sizeOfInputArea/5));
    
    fill(255, 255, 255);
    rect(width/3-sizeOfInputArea/4+(3*sizeOfInputArea)/4, sizeOfInputArea/4+height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2 +sizeOfInputArea/5, sizeOfInputArea/3, sizeOfInputArea/4); //draw left red button
    textAlign(CENTER);
    fill(0, 0, 0);
    text("mno", (width/3-sizeOfInputArea/3+(2*sizeOfInputArea)/4)+(1.5*sizeOfInputArea/3), height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2+(3*sizeOfInputArea/5));
    
    fill(255, 255, 255);
    rect(width/3-sizeOfInputArea/4+(4.35*sizeOfInputArea)/4, sizeOfInputArea/4+height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2 +sizeOfInputArea/5, sizeOfInputArea/3, sizeOfInputArea/4); //draw left red button
    textAlign(CENTER);
    fill(0, 0, 0);
    text("pqrs", (width/3-sizeOfInputArea/3+(2*sizeOfInputArea)/4)+(2.5*sizeOfInputArea/3), height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2+(3*sizeOfInputArea/5));

    // third row
    fill(255, 255, 255);
    rect(width/3-sizeOfInputArea/3+(2*sizeOfInputArea)/4, 2*sizeOfInputArea/4+height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2 +sizeOfInputArea/5, sizeOfInputArea/3, sizeOfInputArea/4); //draw left red button
    textAlign(CENTER);
    fill(0, 0, 0);
    text("tuv", (width/3-sizeOfInputArea/3+(2*sizeOfInputArea)/4)+(1.5/3*sizeOfInputArea/3), height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2+(4.3*sizeOfInputArea/5));
    
    fill(255, 255, 255);
    rect(width/3-sizeOfInputArea/4+(3*sizeOfInputArea)/4, 2*sizeOfInputArea/4+height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2 +sizeOfInputArea/5, sizeOfInputArea/3, sizeOfInputArea/4); //draw left red button
    textAlign(CENTER);
    fill(0, 0, 0);
    text("wxyz", (width/3-sizeOfInputArea/3+(2*sizeOfInputArea)/4)+(1.5*sizeOfInputArea/3), height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2+(4.3*sizeOfInputArea/5));
    
    fill(255, 255, 255);
    rect(width/3-sizeOfInputArea/4+(4.35*sizeOfInputArea)/4, 2*sizeOfInputArea/4+height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2 +sizeOfInputArea/5, sizeOfInputArea/3, sizeOfInputArea/4); //draw left red button
    textAlign(CENTER);
    fill(0, 0, 0);
    text("_", (width/3-sizeOfInputArea/3+(2*sizeOfInputArea)/4)+(2.5*sizeOfInputArea/3), height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2+(4.3*sizeOfInputArea/5));
  
    fill(225);
    text("" + currentLetter, width/2, height/2-sizeOfInputArea/3); //draw current letter
  }
}

//my terrible implementation you can entirely replace
boolean didMouseClick(float x, float y, float w, float h) //simple function to do hit testing
{
  return (mouseX > x && mouseX<x+w && mouseY>y && mouseY<y+h); //check to see if it is in button bounds
}

//my terrible implementation you can entirely replace
void mousePressed()
{
  if (didMouseClick(width/3-sizeOfInputArea/3+(2*sizeOfInputArea)/4, height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2 +sizeOfInputArea/5, sizeOfInputArea/3, sizeOfInputArea/4)) {
    if (lastClick == -1 || lastClick != 0) {
      counter = 0;
      lastClick = 0;
    } else {
      counter = counter+1;
    }
    currentLetter = values[lastClick].charAt(counter%values[lastClick].length());
  }
  else if (didMouseClick(width/3-sizeOfInputArea/4+(3*sizeOfInputArea)/4, height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2 +sizeOfInputArea/5, sizeOfInputArea/3, sizeOfInputArea/4)) {
    if (lastClick == -1 || lastClick != 1) {
      counter = 0;
      lastClick = 1;
    } else {
      counter = counter+1;
    }
    currentLetter = values[lastClick].charAt(counter%values[lastClick].length());
  }
  if (didMouseClick(width/3-sizeOfInputArea/4+(4.35*sizeOfInputArea)/4, height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2 +sizeOfInputArea/5, sizeOfInputArea/3, sizeOfInputArea/4)) {
    if (lastClick == -1 || lastClick != 2) {
      counter = 0;
      lastClick = 2;
    } else {
      counter = counter+1;
    }
    currentLetter = values[lastClick].charAt(counter%values[lastClick].length());
  }
  else if (didMouseClick(width/3-sizeOfInputArea/3+(2*sizeOfInputArea)/4, sizeOfInputArea/4+height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2 +sizeOfInputArea/5, sizeOfInputArea/3, sizeOfInputArea/4)) {
    if (lastClick == -1 || lastClick != 3) {
      counter = 0;
      lastClick = 3;
    } else {
      counter = counter+1;
    }
    currentLetter = values[lastClick].charAt(counter%values[lastClick].length());
  }
  if (didMouseClick(width/3-sizeOfInputArea/4+(3*sizeOfInputArea)/4, sizeOfInputArea/4+height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2 +sizeOfInputArea/5, sizeOfInputArea/3, sizeOfInputArea/4)) {
    if (lastClick == -1 || lastClick != 4) {
      counter = 0;
      lastClick = 4;
    } else {
      counter = counter+1;
    }
    currentLetter = values[lastClick].charAt(counter%values[lastClick].length());
  }
  else if (didMouseClick(width/3-sizeOfInputArea/4+(4.35*sizeOfInputArea)/4, sizeOfInputArea/4+height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2 +sizeOfInputArea/5, sizeOfInputArea/3, sizeOfInputArea/4)) {
    if (lastClick == -1 || lastClick != 5) {
      counter = 0;
      lastClick = 5;
    } else {
      counter = counter+1;
    }
    currentLetter = values[lastClick].charAt(counter%values[lastClick].length());
  }
  if (didMouseClick(width/3-sizeOfInputArea/3+(2*sizeOfInputArea)/4, 2*sizeOfInputArea/4+height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2 +sizeOfInputArea/5, sizeOfInputArea/3, sizeOfInputArea/4)) {
    if (lastClick == -1 || lastClick != 6) {
      counter = 0;
      lastClick = 6;
    } else {
      counter = counter+1;
    }
    currentLetter = values[lastClick].charAt(counter%values[lastClick].length());
  }
  else if (didMouseClick(width/3-sizeOfInputArea/4+(3*sizeOfInputArea)/4, 2*sizeOfInputArea/4+height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2 +sizeOfInputArea/5, sizeOfInputArea/3, sizeOfInputArea/4)) {
    if (lastClick == -1 || lastClick != 7) {
      counter = 0;
      lastClick = 7;
    } else {
      counter = counter+1;
    }
    currentLetter = values[lastClick].charAt(counter%values[lastClick].length());
  }
  else if (didMouseClick(width/3-sizeOfInputArea/4+(4.35*sizeOfInputArea)/4, 2*sizeOfInputArea/4+height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2 +sizeOfInputArea/5, sizeOfInputArea/3, sizeOfInputArea/4)) {
    if (lastClick == -1 || lastClick != 8) {
      counter = 0;
      lastClick = 8;
    } else {
      counter = counter+1;
    }
    currentLetter = values[lastClick].charAt(counter%values[lastClick].length());
  }

  // if (didMouseClick(width/2-sizeOfInputArea/2, height/2-sizeOfInputArea/2+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2)) //check if click in left button
  // {
  //   currentLetter --;
  //   if (currentLetter<'_') //wrap around to z
  //     currentLetter = 'z';
  // }

  // if (didMouseClick(width/2-sizeOfInputArea/2+sizeOfInputArea/2, height/2-sizeOfInputArea/2+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2)) //check if click in right button
  // {
  //   currentLetter ++;
  //   if (currentLetter>'z') //wrap back to space (aka underscore)
  //     currentLetter = '_';
  // }

  if (didMouseClick(width/3-sizeOfInputArea/3+(2*sizeOfInputArea)/4, -sizeOfInputArea/4+height/2-sizeOfInputArea+sizeOfInputArea-sizeOfInputArea/2 +sizeOfInputArea/5, sizeOfInputArea, sizeOfInputArea/4)) //check if click occured in letter area
  {
    if (currentLetter=='_') //if underscore, consider that a space bar
      currentTyped+=" ";
    else if (currentLetter=='`' & currentTyped.length()>0) //if `, treat that as a delete command
      currentTyped = currentTyped.substring(0, currentTyped.length()-1);
    else if (currentLetter!='`') //if not any of the above cases, add the current letter to the typed string
      currentTyped+=currentLetter;
  }

  //You are allowed to have a next button outside the 1" area
  if (didMouseClick(600, 600, 200, 200)) //check if click is in next button
  {
    nextTrial();
  }
}


void nextTrial()
{
  if (currTrialNum >= totalTrialNum) //check to see if experiment is done
    return; //if so, just return

  if (startTime!=0 && finishTime==0) //in the middle of trials
  {
    System.out.println("==================");
    System.out.println("Phrase " + (currTrialNum+1) + " of " + totalTrialNum); //output
    System.out.println("Target phrase: " + currentPhrase); //output
    System.out.println("Phrase length: " + currentPhrase.length()); //output
    System.out.println("User typed: " + currentTyped); //output
    System.out.println("User typed length: " + currentTyped.length()); //output
    System.out.println("Number of errors: " + computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim())); //trim whitespace and compute errors
    System.out.println("Time taken on this trial: " + (millis()-lastTime)); //output
    System.out.println("Time taken since beginning: " + (millis()-startTime)); //output
    System.out.println("==================");
    lettersExpectedTotal+=currentPhrase.trim().length();
    lettersEnteredTotal+=currentTyped.trim().length();
    errorsTotal+=computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim());
  }

  //probably shouldn't need to modify any of this output / penalty code.
  if (currTrialNum == totalTrialNum-1) //check to see if experiment just finished
  {
    finishTime = millis();
    System.out.println("==================");
    System.out.println("Trials complete!"); //output
    System.out.println("Total time taken: " + (finishTime - startTime)); //output
    System.out.println("Total letters entered: " + lettersEnteredTotal); //output
    System.out.println("Total letters expected: " + lettersExpectedTotal); //output
    System.out.println("Total errors entered: " + errorsTotal); //output

    float wpm = (lettersEnteredTotal/5.0f)/((finishTime - startTime)/60000f); //FYI - 60K is number of milliseconds in minute
    float freebieErrors = lettersExpectedTotal*.05; //no penalty if errors are under 5% of chars
    float penalty = max(errorsTotal-freebieErrors, 0) * .5f;
    
    System.out.println("Raw WPM: " + wpm); //output
    System.out.println("Freebie errors: " + freebieErrors); //output
    System.out.println("Penalty: " + penalty);
    System.out.println("WPM w/ penalty: " + (wpm-penalty)); //yes, minus, becuase higher WPM is better
    System.out.println("==================");

    currTrialNum++; //increment by one so this mesage only appears once when all trials are done
    return;
  }

  if (startTime==0) //first trial starting now
  {
    System.out.println("Trials beginning! Starting timer..."); //output we're done
    startTime = millis(); //start the timer!
  } 
  else
    currTrialNum++; //increment trial number

  lastTime = millis(); //record the time of when this trial ended
  currentTyped = ""; //clear what is currently typed preparing for next trial
  currentPhrase = phrases[currTrialNum]; // load the next phrase!
  //currentPhrase = "abc"; // uncomment this to override the test phrase (useful for debugging)
}


void drawWatch()
{
  float watchscale = DPIofYourDeviceScreen/138.0;
  pushMatrix();
  translate(width/2, height/2);
  scale(watchscale);
  imageMode(CENTER);
  image(watch, 0, 0);
  popMatrix();
}


//=========SHOULD NOT NEED TO TOUCH THIS METHOD AT ALL!==============
int computeLevenshteinDistance(String phrase1, String phrase2) //this computers error between two strings
{
  int[][] distance = new int[phrase1.length() + 1][phrase2.length() + 1];

  for (int i = 0; i <= phrase1.length(); i++)
    distance[i][0] = i;
  for (int j = 1; j <= phrase2.length(); j++)
    distance[0][j] = j;

  for (int i = 1; i <= phrase1.length(); i++)
    for (int j = 1; j <= phrase2.length(); j++)
      distance[i][j] = min(min(distance[i - 1][j] + 1, distance[i][j - 1] + 1), distance[i - 1][j - 1] + ((phrase1.charAt(i - 1) == phrase2.charAt(j - 1)) ? 0 : 1));

  return distance[phrase1.length()][phrase2.length()];
}
