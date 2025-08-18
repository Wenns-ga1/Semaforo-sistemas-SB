import pygame
import time
import datetime

# Initialize pygame mixer and window
pygame.mixer.init()
pygame.init()

# Cascaron del semaforo
window_width = 200
window_height = 400
screen = pygame.display.set_mode((window_width, window_height))
pygame.display.set_caption("Smart Stoplight")

# Colores 
GREEN = (0, 255, 0)
YELLOW = (255, 255, 0)
RED = (255, 0, 0)
BLACK = (0, 0, 0)

# Simulacion de la funcion de trafico
def get_simulated_traffic():
    """Simulacion de trafico en base a las horas mas frecuentes de transito."""
    hour = datetime.datetime.now().hour

    if 7 <= hour < 9 or 12 <= hour < 14 or 17 <= hour < 19:
        return "heavy"  # Rush hour
    else:
        return "normal"  # Off-peak

# SEMAFORO 
def draw_stoplight(light_color):
    screen.fill(BLACK)
    pygame.draw.rect(screen, (100, 100, 100), [50, 50, 100, 300])

    pygame.draw.circle(screen, RED if light_color == "red" else (50, 50, 50), (100, 100), 40)
    pygame.draw.circle(screen, YELLOW if light_color == "yellow" else (50, 50, 50), (100, 200), 40)
    pygame.draw.circle(screen, GREEN if light_color == "green" else (50, 50, 50), (100, 300), 40)

    pygame.display.update()

#  Sonidos
def play_sound(light_color):
    try:
        sound = pygame.mixer.Sound(f"{light_color}_test.wav")
        sound.play()
        time.sleep(sound.get_length())  # Wait for the sound to finish before moving on
    except:
        print(f"[Sound missing] {light_color}_test.wav")


#  Entrenamiento del trafico en base a la simulacion
def adjust_for_traffic(light_color, traffic_condition):
    if traffic_condition == "heavy":
        return 5 if light_color == "green" else 2
    else:
        return 3 if light_color == "green" else 2 if light_color == "yellow" else 3

# Loop principal de la simulacion
def stoplight_simulation():
    light_color = "green"
    cycle_count = 0

    while cycle_count < 5:  # Run for 5 cycles
        traffic_condition = get_simulated_traffic()
        print(f"Time: {datetime.datetime.now().strftime('%H:%M:%S')} | Traffic: {traffic_condition} | Light: {light_color}")

        draw_stoplight(light_color)
        play_sound(light_color)

        wait_time = adjust_for_traffic(light_color, traffic_condition)
        time.sleep(wait_time)

        # Random chance of pedestrian detection ^ mejorar para funcionar en base al boton
        if light_color == "red" and datetime.datetime.now().second % 2 == 0:
            print("Pedestrian detected — playing warning sound!")
            try:
                warning = pygame.mixer.Sound("red_test.wav")
                warning.play()
                time.sleep(warning.get_length())
            except:
                print("[Warning sound missing] red_test.wav")

        # Ciclo entre luces
        light_color = {
            "green": "yellow",
            "yellow": "red",
            "red": "green"
        }[light_color]

        cycle_count += 1

    print("Simulation complete.")
    pygame.quit()

# Run the simulation
if __name__ == "__main__":
    stoplight_simulation()
