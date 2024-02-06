// main.c

// Function to clear the framebuffer
void clean_fb(volatile char *fb, int width, int height, int stride) {
    for (volatile char *addr = fb; addr < fb + (width * height * stride); addr += stride)
        *(int*) addr = 0x0;
}

void draw_pixel(volatile char *fb, int x, int y, int width, int stride) {
	long int location = (x * stride) + (y * width * stride);

	*(fb + location) = 255;	// Blue
	*(fb + location + 1) = 255;	// Green
	*(fb + location + 2) = 255;	// Red
	*(fb + location + 3) = 255;	// Full opacity
}

// Entry point of the pseudokernel
void main() {

    clean_fb(0x789b0000, 1080, 2340, 4);

	draw_pixel(0x789b0000, 100, 100, 1080, 2340);
    
}
