#define SDL_MAIN_HANDLED
#include <SDL2/SDL.h>
#include <stdio.h>

#ifdef __EMSCRIPTEN__ 
    #include <emscripten.h>
#endif

SDL_Window *window = NULL;
SDL_Renderer *renderer = NULL;

void on_event(const SDL_Event *ev){

}

void on_update(void){
    SDL_Rect rect = {
        .x = 100,
        .y = 100,
        .w = 200,
        .h = 200
    };
    SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
    SDL_RenderClear(renderer);
    SDL_SetRenderDrawColor(renderer, 10, 60, 250, 255);
    SDL_RenderFillRect(renderer, &rect);
    SDL_RenderPresent(renderer);
}

void handle_mainloop() {
    SDL_Event ev;
    while(SDL_PollEvent(&ev)){
        if(ev.type == SDL_QUIT)
        on_event(&ev);
    }
    on_update();
}

void start_mainloop(){
#ifdef __EMSCRIPTEN__
    emscripten_set_main_loop(handle_mainloop, -1, 1);
#else 
    while (SDL_TRUE){
        handle_mainloop();
    }
#endif
}

int main(int argc, char *argv[]){
    SDL_SetMainReady();
    if(SDL_Init(SDL_INIT_VIDEO) != 0){
        fprintf(stderr, "cannot init SDL\n");
        return -1;
    }

    SDL_DisplayMode DM;
    SDL_GetCurrentDisplayMode(0, &DM);

    window = SDL_CreateWindow(
        "Window", 
        SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 
        800, 600, SDL_WINDOW_SHOWN
    );

    renderer = SDL_CreateRenderer(window, 0, 0);

    if(window == NULL){
        fprintf(stderr, "cannot create SDL window\n");
        return -1;
    }

    start_mainloop();

    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}

