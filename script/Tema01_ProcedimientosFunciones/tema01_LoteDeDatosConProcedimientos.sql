-- Inserción de lote de datos usando procedimientos almacenados
EXEC sp_InsertarMarca 'Volkswagen';
EXEC sp_InsertarMarca 'Kia';
EXEC sp_InsertarMarca 'Hyundai';
EXEC sp_InsertarMarca 'Renault';
EXEC sp_InsertarMarca 'Citroën';
EXEC sp_InsertarMarca 'Jeep';
EXEC sp_InsertarMarca 'Dodge';
EXEC sp_InsertarMarca 'RAM';
EXEC sp_InsertarMarca 'Subaru';
EXEC sp_InsertarMarca 'Mazda';
EXEC sp_InsertarMarca 'Fiat';
EXEC sp_InsertarMarca 'Alfa Romeo';
EXEC sp_InsertarMarca 'Volvo';
EXEC sp_InsertarMarca 'Mitsubishi';
EXEC sp_InsertarMarca 'Suzuki';
EXEC sp_InsertarMarca 'Chery';
EXEC sp_InsertarMarca 'MG';
EXEC sp_InsertarMarca 'Tesla';
EXEC sp_InsertarMarca 'Mini';
EXEC sp_InsertarMarca 'Lexus';

-- Modificar nombre de una marca
EXEC sp_ModificarMarca 2, 'Ford Motor Company'; -- cambiar el primer parametro por el id de la marca que se quiere modificar, seguido del nombre que se desea asignar

-- Eliminar una marca existente
EXEC sp_EliminarMarca 5; -- cambiar por el id de la marca que se quiere eliminar

-- Calcular total estimado de una reserva usando la funcion Total Reserva, recibe como parámetro el precio por día, la fecha de retiro y la fecha de devolución
SELECT dbo.fn_TotalReserva(5000, '2025-11-01', '2025-11-05') AS TotalEstimado;
