import pygame
import math
import datetime

# Инициализация Pygame
pygame.init()

# Константы
WIDTH, HEIGHT = 600, 600
CENTER = (WIDTH // 2, HEIGHT // 2)
OUTER_RADIUS = 250  # Радиус внешнего серого круга
INNER_RADIUS = 200  # Радиус циферблата

# Цвета
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
GRAY = (192, 192, 192)
RED = (255, 0, 0)
DARK_GRAY = (100, 100, 100)

# Создание окна
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Analog Clock")

def draw_wavy_pattern():
    # Рисуем волнистую линию
    for i in range(0, 360, 10):
        angle = math.radians(i)
        x1 = CENTER[0] + OUTER_RADIUS * math.cos(angle)
        y1 = CENTER[1] + OUTER_RADIUS * math.sin(angle)
        x2 = CENTER[0] + (OUTER_RADIUS - 20) * math.cos(angle + math.sin(pygame.time.get_ticks() / 100) * 0.1)
        y2 = CENTER[1] + (OUTER_RADIUS - 20) * math.sin(angle + math.sin(pygame.time.get_ticks() / 100) * 0.1)
        pygame.draw.line(screen, WHITE, (x1, y1), (x2, y2), 2)

    # Рисуем маленькие кружки
    for i in range(0, 360, 30):
        angle = math.radians(i)
        x = CENTER[0] + OUTER_RADIUS * math.cos(angle)
        y = CENTER[1] + OUTER_RADIUS * math.sin(angle)
        pygame.draw.circle(screen, WHITE, (int(x), int(y)), 5)

def draw_clock():
    # Получение текущего времени и даты
    now = datetime.datetime.now()
    hour = now.hour % 12
    minute = now.minute
    second = now.second
    date_str = now.strftime("%d %B %Y")  # Форматирование даты

    # Очистка экрана с градиентом
    for y in range(HEIGHT):
        color = (255 - y // 3, 255 - y // 5, 255 - y // 10)
        pygame.draw.line(screen, color, (0, y), (WIDTH, y))

    # Рисование внешнего серого круга
    pygame.draw.circle(screen, GRAY, CENTER, OUTER_RADIUS, 0)

    # Рисуем волнистый узор на сером круге
    draw_wavy_pattern()

    # Рисование циферблата
    pygame.draw.circle(screen, BLACK, CENTER, INNER_RADIUS, 0)

    # Рисование делений и чисел на циферблате
    for i in range(12):
        angle = math.radians(i * 30)  # 30 градусов между часами
        x = CENTER[0] + (INNER_RADIUS - 20) * math.cos(angle - math.pi / 2)
        y = CENTER[1] + (INNER_RADIUS - 20) * math.sin(angle - math.pi / 2)
        font = pygame.font.Font(None, 36)
        text = font.render(str(i + 1), True, WHITE)
        text_rect = text.get_rect(center=(x, y))
        screen.blit(text, text_rect)

    # Рисование стрелок с эффектом тени
    def draw_hand(length, angle, width, color):
        end_x = CENTER[0] + length * math.cos(angle - math.pi / 2)
        end_y = CENTER[1] + length * math.sin(angle - math.pi / 2)
        pygame.draw.line(screen, DARK_GRAY, CENTER, (end_x + 2, end_y + 2), width)  # Тень
        pygame.draw.line(screen, color, CENTER, (end_x, end_y), width)

    # Часовая стрелка
    hour_angle = math.radians((hour + minute / 60) * 30)  # Угол для часовой стрелки
    draw_hand(INNER_RADIUS * 0.5, hour_angle, 8, WHITE)

    # Минутная стрелка
    minute_angle = math.radians((minute + second / 60) * 6)  # Угол для минутной стрелки
    draw_hand(INNER_RADIUS * 0.7, minute_angle, 6, GRAY)

    # Секундная стрелка
    second_angle = math.radians(second * 6)  # Угол для секундной стрелки
    draw_hand(INNER_RADIUS * 0.9, second_angle, 2, RED)

    # Отображение времени в центре часов
    time_text = now.strftime("%H:%M:%S")
    font = pygame.font.Font(None, 48)
    text_surface = font.render(time_text, True, WHITE)
    text_rect = text_surface.get_rect(center=CENTER)
    screen.blit(text_surface, text_rect)

    # Добавление надписи "Время убить Валеру"
    author_text = "Время убить Валеру"
    author_font = pygame.font.Font(None, 36)
    author_surface = author_font.render(author_text, True, WHITE)
    author_rect = author_surface.get_rect(center=(CENTER[0], CENTER[1] + 40))
    screen.blit(author_surface, author_rect)
    # Рисование черного эллипса вокруг серого круга
    ellipse_rect = (CENTER[0] - OUTER_RADIUS - 10, CENTER[1] - OUTER_RADIUS - 10,
                    OUTER_RADIUS * 2 + 20, OUTER_RADIUS * 2 + 20)
    pygame.draw.ellipse(screen, BLACK, ellipse_rect, 5)

    # Отображение даты под часами
    date_font = pygame.font.Font(None, 36)
    date_surface = date_font.render(date_str, True, BLACK)
    date_rect = date_surface.get_rect(center=(CENTER[0], CENTER[1] + OUTER_RADIUS + 30))
    screen.blit(date_surface, date_rect)

# Главный цикл программы
running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    draw_clock()
    pygame.display.flip()
    pygame.time.delay(1000)

pygame.quit()
