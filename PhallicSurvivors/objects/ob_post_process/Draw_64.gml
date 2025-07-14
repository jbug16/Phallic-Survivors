if (global.drunk_intensity > 0) {
    shader_set(sh_drunk);
    shader_set_uniform_f(shader_get_uniform(sh_drunk, "u_time"), global.drunk_time);
    shader_set_uniform_f(shader_get_uniform(sh_drunk, "u_intensity"), global.drunk_intensity);
    
    draw_surface(application_surface, 0, 0);
    
    shader_reset();
} else {
    draw_surface(application_surface, 0, 0); // fallback so screen still draws
}