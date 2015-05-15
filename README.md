# CoreImage
CoreImageTest 实现PS 的抠图和拼图
效果图
 ![image](https://github.com/justinjing/CoreImage/blob/master/iOS%20Simulator%20Screen%20Shot%202015%E5%B9%B45%E6%9C%8815%E6%97%A5%20%E4%B8%8B%E5%8D%8812.24.57.png)
  ![image](https://github.com/justinjing/CoreImage/blob/master/iOS%20Simulator%20Screen%20Shot%202015%E5%B9%B45%E6%9C%8815%E6%97%A5%20%E4%B8%8B%E5%8D%8812.25.26.png)
主要代码：
```
struct CubeMap {
    int length;
    float dimension;
    float *data;
};

struct CubeMap createCubeMap(float minHueAngle, float maxHueAngle) {
    const unsigned int size = 64;
    struct CubeMap map;
    map.length = size * size * size * sizeof (float) * 4;
    map.dimension = size;
    float *cubeData = (float *)malloc (map.length);
    float rgb[3], hsv[3], *c = cubeData;
    
    for (int z = 0; z < size; z++){
        rgb[2] = ((double)z)/(size-1); // Blue value
        for (int y = 0; y < size; y++){
            rgb[1] = ((double)y)/(size-1); // Green value
            for (int x = 0; x < size; x ++){
                rgb[0] = ((double)x)/(size-1); // Red value
                rgbToHSV(rgb,hsv);
                // Use the hue value to determine which to make transparent
                // The minimum and maximum hue angle depends on
                // the color you want to remove
                float alpha = (hsv[0] > minHueAngle && hsv[0] < maxHueAngle) ? 0.0f: 1.0f;
                // Calculate premultiplied alpha values for the cube
                c[0] = rgb[0] * alpha;
                c[1] = rgb[1] * alpha;
                c[2] = rgb[2] * alpha;
                c[3] = alpha;
                c += 4; // advance our pointer into memory for the next color value
            }
        }
    }
    map.data = cubeData;
    return map;
}

```
苹果没有提供rgbToHSV方法的实现，可以用我找到的这个：
```
void rgbToHSV(float *rgb, float *hsv) {
    float min, max, delta;
    float r = rgb[0], g = rgb[1], b = rgb[2];
    float *h = hsv, *s = hsv + 1, *v = hsv + 2;
    
    min = fmin(fmin(r, g), b );
    max = fmax(fmax(r, g), b );
    *v = max;
    delta = max - min;
    if( max != 0 )
        *s = delta / max;
    else {
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;
    else if( g == max )
        *h = 2 + ( b - r ) / delta;
    else
        *h = 4 + ( r - g ) / delta;
    *h *= 60;
    if( *h < 0 )
        *h += 360;
}
```
在.c文件中导入的库：
```
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

````
