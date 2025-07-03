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
    placa int not null,    
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
create table factura(
	codigoFactura int not null auto_increment,
    codigoClienteFactura int not null,
    codigoEmpleadoFactura int not null,
    codigoAutoFactura int not null,
    fechaEmision date,
    total double(10,2), -- con trigger xd
    metodoPago enum("Targeta","Efectivo"),
    primary key PK_codigoFactura(codigoFactura),
    constraint FK_codigoFactura_Cliente foreign key (codigoClienteFactura)
		references Factura(codigoFactura),
	constraint FK_codigoFactura_Empleado foreign key(codigoEmpleadoFactura)
		references Empleado(codigoEmpleado),
	constraint FK_codigoFactura_Auto foreign key (codigoAutoFactura)
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
