global.drunk_time += 1 / FR;

if (global.drunk_intensity != global.drunk_target) {
    global.drunk_intensity = lerp(global.drunk_intensity, global.drunk_target, global.drunk_fade_speed);
    
    // snap if close enough
    if (abs(global.drunk_intensity - global.drunk_target) < 0.01) {
        global.drunk_intensity = global.drunk_target;
    }
}
