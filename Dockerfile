FROM devkitpro/devkitppc:latest
RUN dkp-pacman -Syu --noconfirm && \
    dkp-pacman -S --noconfirm wiiu-sdl2 wiiu-sdl2_image wiiu-sdl2_mixer wiiu-sdl2_ttf
WORKDIR /work
