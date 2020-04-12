package com.example.heart.imagecheck;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.awt.image.DataBufferByte;
import java.io.File;
import java.io.IOException;

import static com.example.heart.imagecheck.Resize.resize;

public class ImageCheck {
    public static int average_colors(BufferedImage inputImage) {
        byte[] pixelWeight = ((DataBufferByte) inputImage.getRaster().getDataBuffer()).getData();
        int l = pixelWeight.length;
        int totalsum = 0;
        int counter = 0;
        for (int i = 0; i < l; i++) {
            totalsum += pixelWeight[i];
            counter += 1;
        }
        int averageVal = totalsum / counter;
        return averageVal;
    }

    public static BufferedImage greyscale(BufferedImage inputImage) {
        for (int x = 0; x < inputImage.getWidth(); ++x)
            for (int y = 0; y < inputImage.getHeight(); ++y) {
                int rgb = inputImage.getRGB(x, y);
                int r = (rgb >> 16) & 0xFF;
                int g = (rgb >> 8) & 0xFF;
                int b = (rgb & 0xFF);

                int grayLevel = (r + g + b) / 3;
                int gray = (grayLevel << 16) + (grayLevel << 8) + grayLevel;
                inputImage.setRGB(x, y, gray);
            }
        return inputImage;
    }

    public static String compare_bits(BufferedImage inputImage, int inputImageAvg) {
        byte[] pixelWeight = ((DataBufferByte) inputImage.getRaster().getDataBuffer()).getData();
        int l = pixelWeight.length;
        String bitResult = "";
        for (int i = 0; i < l; i++) {

            if (pixelWeight[i] > inputImageAvg)
                bitResult += "1";
            else
                bitResult += "0";
        }
        return bitResult;
    }

    public static int hammingDifference(String bitHash1, String bitHash2) {
        int result = 0;
        for (int i = 0; i < bitHash1.length(); i++)
            if (bitHash1.charAt(i) != bitHash2.charAt(i))
                result += 1;
        return result;
    }

    public static int compare(File file){
        File etalonFile = new File("src/main/resources/etalon-image/etalon.jpg");
        try {

            int scaledWidth = 8;
            int scaledHeight = 8;

            //Считывание изображения
            BufferedImage etalonImage = ImageIO.read(etalonFile);
            //Сжатие изображения
            etalonImage = resize(etalonImage, scaledWidth, scaledHeight);
            //Перевод изображения в градации серого
            etalonImage = greyscale(etalonImage);
            int inputImageAvg = average_colors(etalonImage);
            //Сравнение значений цветов пикселя со средним значением -> если больше то "1", если меньше то "0"
            String bitHash1 = compare_bits(etalonImage, inputImageAvg);

            //Для второго
            BufferedImage inputImage = ImageIO.read(file);
            inputImage = resize(inputImage, scaledWidth, scaledHeight);
            inputImage = greyscale(inputImage);
            int inputImageAvgTwo = average_colors(inputImage);
            String bitHash2 = compare_bits(inputImage, inputImageAvgTwo);
            //побитное сравнение двух хэшей
            int hammingDistance = hammingDifference(bitHash1, bitHash2);

            return (192 - hammingDistance) * 100 / 192;
        } catch (IOException e) {
            System.out.println("Ошибка resize'а изображения");
            e.printStackTrace();
        }
        return 0;
    }
}
