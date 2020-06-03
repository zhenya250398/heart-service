package com.example.heart;

import org.bytedeco.javacpp.opencv_core;
import org.bytedeco.javacv.FFmpegFrameGrabber;
import org.bytedeco.javacv.Frame;
import org.bytedeco.javacv.FrameGrabber;
import org.bytedeco.javacv.OpenCVFrameConverter;

import java.io.File;

import static com.example.heart.FilesActions.copy;
import static org.bytedeco.javacpp.avutil.AV_LOG_QUIET;
import static org.bytedeco.javacpp.avutil.av_log_set_level;
import static org.bytedeco.javacpp.opencv_imgcodecs.imwrite;

public class VideoToFrames {
    public static int loadVideo(String fileName,String uploadPath) throws FrameGrabber.Exception {
        av_log_set_level(AV_LOG_QUIET);
        OpenCVFrameConverter.ToMat converter = new OpenCVFrameConverter.ToMat();
        FrameGrabber videoGrabber = new FFmpegFrameGrabber(uploadPath+"/"+fileName);		//init
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
        int frameNumber=0;
        int each = (int) (Math.round(fps / 2));					//count which frame w need to get
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
                            frameNumber = (int) (cnt / each);
                            imwrite(uploadPath+"/segmentation/"+fileName+"/output.bmp",img);	//save image
                            ProcessBuilder builder = new ProcessBuilder("python", "processing.py");
                            builder.directory(new File(uploadPath + "/segmentation/" + fileName + "/"));
                            builder.redirectError();
                            int newProcess = builder.start().waitFor();
                            copy(uploadPath+"/segmentation/"+fileName+"/output.csv",uploadPath+"/segmentation/"+fileName+"/output"+frameNumber+".csv");
                            copy(uploadPath+"/segmentation/"+fileName+"/output.bmp",uploadPath+"/segmentation/"+fileName+"/output"+frameNumber+".bmp");
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } while (vFrame != null);
        videoGrabber.stop();
        return frameNumber;
    }
}
