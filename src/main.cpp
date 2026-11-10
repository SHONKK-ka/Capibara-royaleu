#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>

int main(int argc, char **argv) {
    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_GAMECONTROLLER) < 0) return 0;
    IMG_Init(IMG_INIT_PNG);

    SDL_Window *window = SDL_CreateWindow("Capibara Royale",
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 1280, 720, SDL_WINDOW_SHOWN);
    SDL_Renderer *renderer = SDL_CreateRenderer(window, -1,
        SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);

    SDL_Surface *surf = IMG_Load("/vol/content/capibara.png");
    if (!surf) surf = IMG_Load("assets/capibara.png");
    SDL_Texture *tex = nullptr;
    if (surf) { tex = SDL_CreateTextureFromSurface(renderer, surf); SDL_FreeSurface(surf); }

    int x = 540, y = 250;
    bool running = true;
    while (running) {
        SDL_Event e;
        while (SDL_PollEvent(&e)) {
            if (e.type == SDL_QUIT) running = false;
        }
        // Mover con el stick izquierdo del GamePad
        for (int i = 0; i < SDL_NumJoysticks(); i++) {
            static SDL_GameController *gc = nullptr;
            if (!gc && SDL_IsGameController(i)) gc = SDL_GameControllerOpen(i);
            if (gc) {
                int ax = SDL_GameControllerGetAxis(gc, SDL_CONTROLLER_AXIS_LEFTX);
                int ay = SDL_GameControllerGetAxis(gc, SDL_CONTROLLER_AXIS_LEFTY);
                if (ax > 8000 || ax < -8000) x += ax / 4000;
                if (ay > 8000 || ay < -8000) y += ay / 4000;
            }
        }
        SDL_SetRenderDrawColor(renderer, 135, 206, 235, 255);
        SDL_RenderClear(renderer);
        SDL_Rect ground = {0, 400, 1280, 320};
        SDL_SetRenderDrawColor(renderer, 34, 139, 34, 255);
        SDL_RenderFillRect(renderer, &ground);
        if (tex) { SDL_Rect dst = {x, y, 200, 200}; SDL_RenderCopy(renderer, tex, NULL, &dst); }
        SDL_RenderPresent(renderer);
    }
    if (tex) SDL_DestroyTexture(tex);
    IMG_Quit();
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}
