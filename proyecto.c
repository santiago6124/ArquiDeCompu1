#include <stdio.h>
#include <unistd.h>
#include <stdbool.h>
#include <string.h>
#include <termios.h>
#include <stdlib.h>
#include <ncurses.h>
#include "EasyPIO.h"

extern void formula1(void);
extern void colision_asm(void);

void disp_binary(int);
void delay(int);
void autofantastico();
void choque();
void f1();
void colision();
void menu();

void delay(int time)
{
   usleep(time * 1000);
}

void leds(int i)
{
   const char led[] = {14, 15, 18, 23, 24, 25, 8, 7};
   int indice = 0;
   int t;
   for (t = 128; t > 0; t = t / 2)
   {
      if (i & t)
         digitalWrite(led[indice], 1);
      else
         digitalWrite(led[indice], 0);
      indice++;
   }
}
/**
 * @brief Maneja la entrada del teclado para las animaciones.
 * * @param on_time Puntero a la variable de velocidad de la animación.
 * @param step La cantidad a sumar o restar de on_time.
 * @param min_time El valor mínimo para on_time.
 * @param max_time El valor máximo para on_time.
 * @return true si el usuario presionó 'q' (indica que hay que salir).
 * @return false si la animación debe continuar.
 */
bool manejar_teclado(int *on_time, int step, int min_time, int max_time)
{
    int c = getch(); // Lee una tecla

    if (c == 'q')
    {
        endwin();
        system("clear");
        return true; // Sí, hay que salir
    }
    else if (c == KEY_UP)
    {
        *on_time -= step; // Modifica el valor a través del puntero
        if (*on_time < min_time)
        {
            *on_time = min_time;
        }
    }
    else if (c == KEY_DOWN)
    {
        *on_time += step; // Modifica el valor a través del puntero
        if (*on_time > max_time)
        {
            *on_time = max_time;
        }
    }

    return false; // No, no hay que salir
}
void disp_binary(int i)
{
   int t;
   leds(i);
   for (t = 128; t > 0; t = t / 2)
   {
      if (i & t)
         printf("* ");
      else
         printf("_ ");
   }
   printf("\n");
}

void readPassword(char *password, int maxLength)
{
   struct termios oldTerm, newTerm;

   tcgetattr(fileno(stdin), &oldTerm);
   newTerm = oldTerm;
   newTerm.c_lflag &= ~(ECHO | ECHOE | ECHOK | ECHONL | ICANON);
   tcsetattr(fileno(stdin), TCSANOW, &newTerm);

   int i = 0;
   char c;
   while (i < maxLength - 1 && (c = getchar()) != '\n')
   {
      password[i++] = c;
      putchar('*');
   }
   password[i] = '\0';

   tcsetattr(fileno(stdin), TCSANOW, &oldTerm);
   putchar('\n');
}

void autofantastico()
{
   unsigned char output;
   int on_time = 200;
   int min_time = 20;
   int max_time = 500;

   initscr();
   keypad(stdscr, TRUE);
   nodelay(stdscr, TRUE);
   noecho();

   mvprintw(0, 0, "Has elegido la Función de Auto Fantástico:\n\n(Para salir pulsa la tecla 'q'. Para cambiar la velocidad, con las flechas))\n\n");
   refresh();

   while (1)
   {
      output = 0x80;

      for (int i = 0; i < 8; i++)
      {
         disp_binary(output);
         delay(on_time);
         output = output >> 1;
         printf("\033[A\r");

         if (manejar_teclado(&on_time, 20, min_time, max_time))
         {
            return;
         }
      }

      output = 0x01;

      for (int i = 0; i < 6; i++)
      {
         output = output << 1;
         disp_binary(output);
         delay(on_time);
         printf("\033[A\r");

         if (manejar_teclado(&on_time, 20, min_time, max_time))
         {
            return;
         }
      }
   }
}

void choque()
{
   unsigned char output;
   int on_time = 200;
   int min_time = 20;
   int max_time = 500;

   unsigned char patrones[] = {0x81, 0x42, 0x24, 0x18, 0x24, 0x42, 0x81};

   initscr();
   keypad(stdscr, TRUE);
   nodelay(stdscr, TRUE);
   noecho();

   mvprintw(0, 0, "Has elegido la Función del Choque:\n\n(Para salir pulsa la tecla 'q'. Para cambiar la velocidad, con las flechas)\n\n");
   refresh();

   while (1)
   {
      for (int i = 0; i < 7; i++)
      {
         output = patrones[i];
         disp_binary(output);
         delay(on_time);
         printf("\033[A\r");

         if (manejar_teclado(&on_time, 20, min_time, max_time))
         {
            return;
         }
      }
   }
}

void f1()
{
   unsigned char output;
   int on_time = 500;
   int min_time = 200;
   int max_time = 1000;

   initscr();
   keypad(stdscr, TRUE);
   nodelay(stdscr, TRUE);
   noecho();

   mvprintw(0, 0, "Has elegido la Función de Fórmula 1:\n\n(Para salir pulsa la tecla 'q')\n\n");
   refresh();

   while (1)
   {
      output = 0x80;
      for (int i = 2; i < 512; i = (i * 2) + 2)
      {
         disp_binary(output);
         delay(on_time);
         output = output + (output / i);
         printf("\033[A\r");

         if (manejar_teclado(&on_time, 100, min_time, max_time))
         {
            return;
         }
      }
      output = 0x00;
      disp_binary(output);
      delay(on_time);
      printf("\033[A\r");
   }
}

void colision()
{
   unsigned char output;
   int on_time = 200;
   int min_time = 20;
   int max_time = 500;

   unsigned char patrones[] = {0x81,0xC3,0xE7,0xFF,0xE7,0xC3,0x81,0x00};
   int num_pasos = sizeof(patrones) / sizeof(patrones[0]);

   initscr();
   keypad(stdscr, TRUE);
   nodelay(stdscr, TRUE);
   noecho();

   mvprintw(0, 0, "Has elegido la Función de Colisión al Centro:\n\n(Para salir pulsa la tecla 'q'. Para cambiar la velocidad, con las flechas)\n\n");
   refresh();

   while (1)
   {
      for (int i = 0; i < num_pasos; i++)
      {
         output = patrones[i];
         disp_binary(output);
         delay(on_time);
         printf("\033[A\r");

         if (manejar_teclado(&on_time, 20, min_time, max_time))
         {
            return;
         }
      }
   }
}

void menu()
{
   int opcion;

   while (1)
   {
      printf("\n   MENU  \n");
      printf("1) Auto Fantastico\n");
      printf("2) Choque\n");
      printf("3) Formula 1\n");
      printf("4) Colisión al Centro\n");
      printf("5) Salir\n");
      printf("Elija su opcion: ");

      if (scanf("%d", &opcion) != 1)
      {
         printf("Opcion no valida\n");
         while (getchar() != '\n')
            ;
         continue;
      }

      switch (opcion)
      {
      case 1:
         autofantastico();
         break;
      case 2:
         choque();
         break;
      case 3:
         formula1();
         break;
      case 4:
         colision_asm();
         break;
      case 5:
         printf("Saliendo del programa...\n");
         exit(0);
      default:
         printf("Opcion no valida\n");
      }
   }
}

int main()
{
   pioInit();
   const char led[] = {14, 15, 18, 23, 24, 25, 8, 7};
   for (int i = 0; i < 8; i++)
   {
      pinMode(led[i], OUTPUT);
   }
   leds(0x00);

   int intentos = 0;
   char clave[] = "13524";

   while (intentos < 3)
   {
      char password[50];

      printf("Ingrese su password: ");
      readPassword(password, sizeof(password));

      if (strcmp(password, clave) == 0)
      {
         printf("\nBienvenido al Sistema!\n");
         menu();
      }
      else
      {
         printf("Password no válida\n");
         intentos++;
      }
   }

   if (intentos == 3)
   {
      printf("Se excedió el número máximo de intentos. El programa abortará.\n");
   }

   return 0;
}
