package com.example.heart;

import org.bytedeco.javacpp.opencv_core;
import org.bytedeco.javacv.FFmpegFrameGrabber;
import org.bytedeco.javacv.Frame;
import org.bytedeco.javacv.FrameGrabber;
import org.bytedeco.javacv.OpenCVFrameConverter;

import static org.bytedeco.javacpp.opencv_imgcodecs.imwrite;

public class VideoToFrames {
    public static void loadVideo() {
        OpenCVFrameConverter.ToMat converter = new OpenCVFrameConverter.ToMat();
        FrameGrabber videoGrabber = new FFmpegFrameGrabber("C:/Users/zhenya/Desktop/Landscape.mp4");		//init
        try {
            videoGrabber.setFormat("mp4");									// mp4 for example
            videoGrabber.start();											//start
        } catch (Exception e) {
            e.printStackTrace();
        }

        Frame vFrame = null;
        double fps = videoGrabber.getFrameRate();							//get fps

        System.out.println(fps);

        int cnt = 0;
        int each = (int) (Math.round(fps / 25));					//count which frame w need to get
        if (each > 1)
            each--;															// for example each 12`th if we have fps = 25
        // that mean we have 2 image per second
        do {
            try {
                vFrame = videoGrabber.grabFrame();							//grab
                if (vFrame != null) {
                    opencv_core.Mat img = converter.convert(vFrame);


                    if (img != null) {
                        cnt++;
                        if (cnt % each == 0) {
                            int seconds = (int) (cnt / fps);
                            imwrite("C:/Users/zhenya/uploadImages/video/f_"+seconds+".png",img);	//save image
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } while (vFrame != null);
    }
}
