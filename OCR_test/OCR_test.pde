// https://discourse.processing.org/t/i-have-a-question-regarding-ocr/39466
// https://www.geeksforgeeks.org/tesseract-ocr-with-java-with-examples/

import java.io.File;
  
import net.sourceforge.tess4j.Tesseract;
import net.sourceforge.tess4j.TesseractException;


  
void setup(){
  Tesseract tesseract = new Tesseract();
  try {
  
      tesseract.setDatapath("");
  
      // the path of your tess data folder
      // inside the extracted file
      String text
          = tesseract.doOCR(new File("test.jpg"));
  
      // path of your image file
      print(text);
  } catch (TesseractException e) {
      e.printStackTrace();
  }
}
