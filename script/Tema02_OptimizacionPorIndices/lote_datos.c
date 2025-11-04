#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// Variables globales
FILE * archivo;

float importe = 0; // al trabajar sobre una tabla de prueba para testeo no se tienen en cuenta los registros de detalle_metodo_pago
int anio = 0, mes = 0, dia = 0, idDetalleMetodoPago = 0, idReserva = 0, idMetodoPago = 0;

// Prototipo para calcular el importe
void CalcularImporte(int, int);

// Función principal
int main() {
	srand(time(NULL));
	
	archivo = fopen("bulk_test.txt", "w");
	fprintf(archivo, "importe,fecha_pago,id_detalle_metodo_pago,id_reserva,id_metodo_pago\n");
	
	for (int x = 0; x < 1000000; x++) {
		CalcularImporte(40000, 130000);
		anio = rand() % (2025 + 1 - 2015) + 2015;
		
		if (anio != 2025) {
			mes = rand() % (12 + 1 - 1) + 1;
		} else {
			mes = rand() % (10 + 1 - 1) + 1;
		}
		
		
		switch(mes) {
			case 1:
			case 3:
			case 5:
			case 7:
			case 8:
			case 10:
			case 12:
				dia = rand() % (31 + 1 - 1) + 1;
				break;
			case 4:
			case 6:
			case 9:
			case 11:
				dia = rand() % (30 + 1 - 1) + 1;
				break;	
			case 2:
				dia = rand() % (28 + 1 - 1) + 1;
				break;
		}		
		
		idMetodoPago = rand() % 3 + 1;
		idDetalleMetodoPago++, idReserva++;
		
		if (mes < 10 && dia < 10) {
			fprintf (archivo, "%.2f,%d-0%d-0%d,%d,%d,%d\n", importe, anio, mes, dia, idDetalleMetodoPago, idReserva, idMetodoPago);		
		} else if (mes < 10 && dia >= 10) {
			fprintf (archivo, "%.2f,%d-0%d-%d,%d,%d,%d\n", importe, anio, mes, dia, idDetalleMetodoPago, idReserva, idMetodoPago);
		} else if (dia < 10 && mes >= 10) {
			fprintf (archivo, "%.2f,%d-%d-0%d,%d,%d,%d\n", importe, anio, mes, dia, idDetalleMetodoPago, idReserva, idMetodoPago);
		} else {
			fprintf (archivo, "%.2f,%d-%d-%d,%d,%d,%d\n", importe, anio, mes, dia, idDetalleMetodoPago, idReserva, idMetodoPago);
		}
	}
}

// Desarrollo de función para calcular el importe
void CalcularImporte(int p_min, int p_max) {
	float scale = rand() / (float) RAND_MAX; 
	importe = p_min + scale * (p_max - p_min);
}
