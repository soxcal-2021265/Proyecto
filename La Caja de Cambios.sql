-- La Caja de Cambios
-- Pulso Mecánico
drop database if exists DB_Taller;
create database DB_Taller;
use DB_Taller;

-- empleado
create table Empleado(
	codigoEmpleado int not null auto_increment,
    nombreEmpleado varchar(250) not null,
    telefonoEmpleado char(8) not null unique,
    correoEmpleado varchar(250) not null unique,
    direccion varchar(250),
    puesto enum ("Recepcionista","Mecanico"),
    primary key PK_codigoEmpleado(codigoEmpleado)
);
-- CLIENTE/USUARIO
create table Cliente(
	codigoCliente int not null auto_increment,
    nombreCliente varchar(250) not null,
    telefonoCliente char(8)not null unique,
    correoCliente varchar(250) not null unique,
    direccion varchar(250),
    primary key PK_codigoCliente(codigoCliente)
);
-- AUTO
create table Auto(
	codigoAuto int not null auto_increment,
    codigoCliente int not null,    
    placa varchar(7) not null,    
    marca varchar(250),
    modelo varchar(250),
    color varchar(250),
    primary key PK_codigoAuto (codigoAuto),
    constraint FK_Auto_Cliente foreign key (codigoCliente)
		references Cliente (codigoCliente)
);
-- TIENDA DE LLANTAS
create table Llanta(
	codigoLlanta int not null auto_increment,
    anchoMilimentos int not null, -- ancho de lado a lado
    perfil int not null,  -- ofrece estabilidad
    tipoConstruccion enum("Radial","Diagonal","Cinturada") not null,-- durabilidad y agarre
    diametroRin int not null, -- diametro en pulgadas 
    cargaMaximakg int not null,
    primary key PK_codigoLlanta (codigoLlanta)
);
-- insert into Llanta(anchoMilimentos, perfil, tipoConstruccion, diametroRin, cargaMaximakg)
-- value("250","22","Radial","23","91");
-- repuestos
create table Repuesto(
	codigoRepuesto int not null auto_increment,
    nombreRepuesto varchar(250) not null,
    descripcionRepuesto varchar(250) not null,
    precioRepuesto double(10,2) not null,
    stockRepuesto int,
    estadoRepuesto enum("Disponibles","Agotados") not null,
    primary key PK_codigoRepuesto(codigoRepuesto)
);
-- accesorios
create table Accesorio(
	codigoAccesorio int not null auto_increment,
    nombreAccesorio varchar(250) not null,
    descripcionAccesorio varchar(250)not null,
    precioAccesorio double (10,2)not null,
    stockAccesorio int,
    estadoAccesorio enum("Disponibles","Agotados") not null,
    primary key PK_codigoAccesorio(codigoAccesorio)
);
-- Servicios / mantenimientos
create table Servicio(
	codigoServicio int not null auto_increment,
    nombreServicio varchar(250) not null,
    descripcionServicio varchar(250)not null,
    precioServicio double(10,2)not null,
    primary key PK_codigoServicio(codigoServicio)
);
-- order de servicio
create table OrdenServicio(
	codigoOrdenServicio int not null auto_increment,
    codigoAuto int not null,
    codigoCliente int not null,
    codigoEmpleado int not null,
    codigoServicio int not null,
    fechaIngreso date,
    estado enum("Pendiente","En proceso","Finalizado"),
    primary key PK_codigoOrdenServicio(codigoOrdenServicio),
    constraint FK_ordenServicio_Auto foreign key(codigoAuto)
		references Auto(codigoAuto),
	constraint FK_ordenServicio_Cliente foreign key(codigoCliente)
		references Cliente(codigoCliente),
	constraint FK_ordenServicio_Empleado foreign key(codigoEmpleado)
		references Empleado(codigoEmpleado),
	constraint FK_ordenServicio_Servicio foreign key(codigoServicio)
		references Servicio(codigoServicio)
);
-- Reparacion /cambios de piesas
create table Reparacion(
	codigoReparacion int not null auto_increment,
	nombreReparacion varchar(250) not null,
    descripcionReparacion varchar(250)not null,
    precioReparacion double(10,2)not null,
    primary key PK_codigoReparacion(codigoReparacion)
);
-- Orden Reparacion 
create table OrdenReparacion(
	codigoOrdenReparacion int not null auto_increment,
	codigoAutoReparacion int not null,
    codigoClienteReparacion int not null,
    codigoEmpleadoReparacion int not null,
    codigoReparacion int not null,
    fechaIngresoReparacion date,
    estadoReparacion enum("Pendiente","En proceso","Finalizado"),
    primary key PK_codigoOrdenReparacion(codigoOrdenReparacion),
    constraint FK_ordenReparacion_Auto foreign key(codigoAutoReparacion)
		references Auto(codigoAuto),
	constraint FK_ordenReparacion_Cliente foreign key(codigoClienteReparacion)
		references Cliente(codigoCliente),
	constraint FK_ordenReparacion_Empleado foreign key(codigoEmpleadoReparacion)
		references Empleado(codigoEmpleado),
	constraint FK_ordenReparacion_Reparacion foreign key(codigoReparacion)
		references Reparacion(codigoReparacion)
);		
-- factura
create table Factura(
	codigoFactura int not null auto_increment,
    codigoClienteFactura int not null,
    codigoEmpleadoFactura int not null,
    codigoAutoFactura int not null,
    fechaEmision date,
    total double(10,2), -- con trigger xd
    metodoPago enum("Targeta","Efectivo"),
    primary key PK_codigoFactura(codigoFactura),
    constraint FK_codigoClienteFactura foreign key(codigoClienteFactura)
		references Cliente(codigoCliente),
	constraint FK_codigoEmpleadoFactura foreign key(codigoEmpleadoFactura)
		references Empleado(codigoEmpleado),
	constraint FK_codigoAutoFactura foreign key(codigoAutoFactura)
		references Auto(codigoAuto)
);
-- detalleFactura
create table DetalleFactura (
    codigoDetalleFactura int not null auto_increment,
    codigoFactura int not null,
    tipoGasto enum('Servicio','Repuesto','Accesorio','Reparacion','llanta'),
    codigoGasto int, -- La id del tipoGasto, lo buscamos con un proceso almacenado especifico
    cantidad int not null,
    primary key PK_DetalleFactura (codigoDetalleFactura),
    constraint FK_DetalleFactura_Factura foreign key (codigoFactura)
		references Factura(codigoFactura)
);

-- PROCEDIMIENTOS ALMACENADOS
-- CLIENTE

delimiter //
create procedure sp_ListarCliente()
begin
	select codigoCliente, nombreCliente, telefonoCliente, correoCliente, direccion from Cliente;
end //
delimiter ;
call sp_ListarCliente();

delimiter //
create procedure sp_AgregarCliente(
	in nCliente varchar(250),
    in tCliente char(8),
    in cCliente varchar(250),
    in dCliente varchar(250)
    )
begin
	insert into Cliente(nombreCliente, telefonoCliente, correoCliente, direccion)
    values (nCliente, tCliente, cCliente, dCliente);
end //
delimiter ;
call sp_AgregarCliente('Ana López','12345678','ana.lopez@gmail.com','Zona 1');
call sp_AgregarCliente('Carlos Méndez','23456789','carlos.m@gmail.com','Zona 2');
call sp_AgregarCliente('Lucía Torres','34567890','lucia.t@gmail.com','Zona 3');
call sp_AgregarCliente('Mario Ruiz','45678901','mario.r@gmail.com','Zona 4');
call sp_AgregarCliente('Sandra Díaz','56789012','sandra.d@gmail.com','Zona 5');
call sp_AgregarCliente('José Ramírez','67890123','jose.r@gmail.com','Zona 6');
call sp_AgregarCliente('Paola Soto','78901234','paola.s@gmail.com','Zona 7');
call sp_AgregarCliente('Luis Castillo','89012345','luis.c@gmail.com','Zona 8');
call sp_AgregarCliente('Diana Pérez','90123456','diana.p@gmail.com','Zona 9');
call sp_AgregarCliente('Héctor Gómez','10234567','hector.g@gmail.com','Zona 10');
call sp_AgregarCliente('Andrea Cruz','11234567','andrea.c@gmail.com','Zona 11');

delimiter //
create procedure sp_EliminarCliente(in cCliente int)
begin
	delete from Cliente where codigoCliente = cCliente;
end //
delimiter ;
-- call sp_EliminarCliente(6);

delimiter //
create procedure sp_ModificarCliente(
	in cCliente int, 
    in nCliente varchar(250),
    in tCliente char(8),
    in coCliente varchar(250),
    in dCliente varchar(250)
)
begin
	update Cliente
    set nombreCliente = nCliente,
		telefonoCliente = tCliente,
        correoCliente = coCliente,
        direccion = dCliente
	where codigoCliente = cCliente;
end //
delimiter ;
-- call sp_ModificarCliente(1, 'Andre', 12123123, 'asdasd@gmail.com', 'zona 1');

delimiter //
create procedure sp_BuscarCliente(in cCliente int)
begin
	select codigoCliente, nombreCliente, telefonoCliente, correoCliente, direccion from Cliente
    where codigoCliente = cCliente;
end //
delimiter ;
-- call sp_BuscarCliente(1);


-- AUTO
delimiter //
create procedure sp_ListarAuto()
begin
	select codigoAuto, codigoCliente, placa, marca, modelo, color from Auto;
end //
delimiter ;
call sp_ListarAuto();

delimiter //
create procedure sp_AgregarAuto(
	in cCliente int,
    in pAuto varchar(7), 
    in mAuto varchar(250), 
    in moAuto varchar(250), 
    in cAuto varchar(250)
)
begin
	insert into Auto(codigoCliente, placa, marca, modelo, color)
    values(cCliente, pAuto, mAuto, moAuto, cAuto);
end //
delimiter ;
call sp_AgregarAuto(1,'P123AAA','Toyota','Corolla','Blanco');
call sp_AgregarAuto(2,'P234BBB','Honda','Civic','Negro');
call sp_AgregarAuto(3,'P345CCC','Mazda','3','Rojo');
call sp_AgregarAuto(4,'P456DDD','Hyundai','Elantra','Azul');
call sp_AgregarAuto(5,'P567EEE','Kia','Rio','Gris');
call sp_AgregarAuto(6,'P678FFF','Nissan','Versa','Plateado');
call sp_AgregarAuto(7,'P789GGG','Chevrolet','Aveo','Verde');
call sp_AgregarAuto(8,'P890HHH','Ford','Fiesta','Negro');
call sp_AgregarAuto(9,'P901III','Volkswagen','Jetta','Blanco');
call sp_AgregarAuto(10,'P012JJJ','Subaru','Impreza','Azul');
call sp_AgregarAuto(11,'P123KKK','Suzuki','Swift','Rosado');

delimiter //
create procedure sp_EliminarAuto(in cAuto int)
begin
	delete from Auto where codigoAuto = cAuto;
end //
delimiter ;
-- call sp_EliminarAuto(2);

delimiter //
create procedure sp_ModificarAuto(
	in cAuto int,
    in cCliente int,
    in pAuto varchar(7), 
    in mAuto varchar(250),
    in moAuto varchar(250),
    in coAuto varchar(250)
)
begin
	update Auto
    set codigoCliente = cCliente, 
        placa = pAuto,
        marca = mAuto,
        modelo = moAuto, 
        color = coAuto
	where codigoAuto = cAuto;
end //
delimiter ;
-- call sp_ModificarAuto (1, 1, 'P123IOP', 'Supra', 'mk', 'negrito');

delimiter //
create procedure sp_BuscarAuto(in cAuto int)
begin	
	select codigoCliente, placa, marca, modelo, color from Auto
    where codigoAuto = cAuto;
end //
delimiter ;
call sp_BuscarAuto(1);