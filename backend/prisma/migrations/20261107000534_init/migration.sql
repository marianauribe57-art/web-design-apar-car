-- CreateEnum
CREATE TYPE "Rol" AS ENUM ('ADMINISTRADOR', 'OPERARIO', 'CLIENTE');

-- CreateEnum
CREATE TYPE "EstadoAfiliacion" AS ENUM ('PENDIENTE_VINCULACION', 'ACTIVA', 'INACTIVA');

-- CreateEnum
CREATE TYPE "TipoCelda" AS ENUM ('CARRO', 'MOTO', 'MIXTA');

-- CreateEnum
CREATE TYPE "EstadoCelda" AS ENUM ('LIBRE', 'OCUPADA');

-- CreateEnum
CREATE TYPE "TipoVehiculo" AS ENUM ('CARRO', 'MOTO');

-- CreateEnum
CREATE TYPE "EstadoCodigoQr" AS ENUM ('ACTIVO', 'REVOCADO');

-- CreateEnum
CREATE TYPE "OrigenMovimiento" AS ENUM ('MANUAL', 'LECTOR_QR');

-- CreateEnum
CREATE TYPE "MedioPago" AS ENUM ('EFECTIVO', 'TRANSFERENCIA', 'OTRO');

-- CreateTable
CREATE TABLE "Usuario" (
    "id" UUID NOT NULL,
    "correo" TEXT NOT NULL,
    "hashContrasena" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "telefono" TEXT NOT NULL,
    "debeCambiarContrasena" BOOLEAN NOT NULL DEFAULT false,
    "intentosFallidos" INTEGER NOT NULL DEFAULT 0,
    "bloqueadoHasta" TIMESTAMPTZ,
    "activo" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "Usuario_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Consentimiento" (
    "id" UUID NOT NULL,
    "usuarioId" UUID NOT NULL,
    "versionPolitica" TEXT NOT NULL,
    "aceptadoEn" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Consentimiento_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Afiliacion" (
    "id" UUID NOT NULL,
    "parqueaderoId" UUID NOT NULL,
    "usuarioId" UUID,
    "rol" "Rol" NOT NULL,
    "estado" "EstadoAfiliacion" NOT NULL,
    "nombreTitular" TEXT NOT NULL,
    "telefonoTitular" TEXT NOT NULL,
    "creadoEn" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Afiliacion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Parqueadero" (
    "id" UUID NOT NULL,
    "nombre" TEXT NOT NULL,
    "direccion" TEXT NOT NULL,
    "creadoEn" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Parqueadero_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Celda" (
    "id" UUID NOT NULL,
    "parqueaderoId" UUID NOT NULL,
    "codigo" TEXT NOT NULL,
    "tipoPermitido" "TipoCelda" NOT NULL,
    "estado" "EstadoCelda" NOT NULL DEFAULT 'LIBRE',

    CONSTRAINT "Celda_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tarifa" (
    "id" UUID NOT NULL,
    "parqueaderoId" UUID NOT NULL,
    "valorHora" DECIMAL(10,2) NOT NULL,
    "valorDia" DECIMAL(10,2) NOT NULL,
    "valorMensualidad" DECIMAL(10,2) NOT NULL,
    "vigenteDesde" TIMESTAMPTZ NOT NULL,
    "vigenteHasta" TIMESTAMPTZ,

    CONSTRAINT "Tarifa_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Vehiculo" (
    "id" UUID NOT NULL,
    "parqueaderoId" UUID NOT NULL,
    "placa" TEXT NOT NULL,
    "tipo" "TipoVehiculo" NOT NULL,

    CONSTRAINT "Vehiculo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VinculoVehiculo" (
    "id" UUID NOT NULL,
    "parqueaderoId" UUID NOT NULL,
    "afiliacionId" UUID NOT NULL,
    "vehiculoId" UUID NOT NULL,
    "fechaInicio" TIMESTAMPTZ NOT NULL,
    "fechaFin" TIMESTAMPTZ,

    CONSTRAINT "VinculoVehiculo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CodigoVinculacion" (
    "id" UUID NOT NULL,
    "parqueaderoId" UUID NOT NULL,
    "afiliacionId" UUID NOT NULL,
    "hashCodigo" TEXT NOT NULL,
    "intentosFallidos" INTEGER NOT NULL DEFAULT 0,
    "venceEn" TIMESTAMPTZ NOT NULL,
    "usadoEn" TIMESTAMPTZ,

    CONSTRAINT "CodigoVinculacion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CodigoQr" (
    "id" UUID NOT NULL,
    "parqueaderoId" UUID NOT NULL,
    "vehiculoId" UUID NOT NULL,
    "token" TEXT NOT NULL,
    "estado" "EstadoCodigoQr" NOT NULL DEFAULT 'ACTIVO',
    "emitidoEn" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "revocadoEn" TIMESTAMPTZ,

    CONSTRAINT "CodigoQr_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Movimiento" (
    "id" UUID NOT NULL,
    "parqueaderoId" UUID NOT NULL,
    "celdaId" UUID NOT NULL,
    "tarifaId" UUID NOT NULL,
    "vehiculoId" UUID,
    "registradoPorId" UUID NOT NULL,
    "dispositivoId" UUID,
    "placa" TEXT NOT NULL,
    "tipoVehiculo" "TipoVehiculo" NOT NULL,
    "codigoTiquete" TEXT,
    "origen" "OrigenMovimiento" NOT NULL,
    "entradaEn" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "salidaEn" TIMESTAMPTZ,
    "valorCobrado" DECIMAL(10,2) NOT NULL,
    "anulado" BOOLEAN NOT NULL DEFAULT false,
    "motivoAnulacion" TEXT,

    CONSTRAINT "Movimiento_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Pago" (
    "id" UUID NOT NULL,
    "parqueaderoId" UUID NOT NULL,
    "afiliacionId" UUID NOT NULL,
    "tarifaId" UUID NOT NULL,
    "monto" DECIMAL(10,2) NOT NULL,
    "medioPago" "MedioPago" NOT NULL,
    "fechaPago" TIMESTAMPTZ NOT NULL,
    "periodoDesde" TIMESTAMPTZ NOT NULL,
    "periodoHasta" TIMESTAMPTZ NOT NULL,
    "anulado" BOOLEAN NOT NULL DEFAULT false,
    "motivoAnulacion" TEXT,

    CONSTRAINT "Pago_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Dispositivo" (
    "id" UUID NOT NULL,
    "parqueaderoId" UUID NOT NULL,
    "nombre" TEXT NOT NULL,
    "hashClave" TEXT NOT NULL,
    "activo" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "Dispositivo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Bitacora" (
    "id" UUID NOT NULL,
    "parqueaderoId" UUID NOT NULL,
    "usuarioId" UUID,
    "accion" TEXT NOT NULL,
    "entidad" TEXT NOT NULL,
    "detalle" JSONB NOT NULL,
    "creadoEn" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Bitacora_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Usuario_correo_key" ON "Usuario"("correo");

-- CreateIndex
CREATE UNIQUE INDEX "Celda_parqueaderoId_codigo_key" ON "Celda"("parqueaderoId", "codigo");

-- CreateIndex
CREATE UNIQUE INDEX "Vehiculo_parqueaderoId_placa_key" ON "Vehiculo"("parqueaderoId", "placa");

-- CreateIndex
CREATE UNIQUE INDEX "CodigoQr_token_key" ON "CodigoQr"("token");

-- CreateIndex
CREATE UNIQUE INDEX "Movimiento_codigoTiquete_key" ON "Movimiento"("codigoTiquete");

-- AddForeignKey
ALTER TABLE "Consentimiento" ADD CONSTRAINT "Consentimiento_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Afiliacion" ADD CONSTRAINT "Afiliacion_parqueaderoId_fkey" FOREIGN KEY ("parqueaderoId") REFERENCES "Parqueadero"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Afiliacion" ADD CONSTRAINT "Afiliacion_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "Usuario"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Celda" ADD CONSTRAINT "Celda_parqueaderoId_fkey" FOREIGN KEY ("parqueaderoId") REFERENCES "Parqueadero"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tarifa" ADD CONSTRAINT "Tarifa_parqueaderoId_fkey" FOREIGN KEY ("parqueaderoId") REFERENCES "Parqueadero"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vehiculo" ADD CONSTRAINT "Vehiculo_parqueaderoId_fkey" FOREIGN KEY ("parqueaderoId") REFERENCES "Parqueadero"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VinculoVehiculo" ADD CONSTRAINT "VinculoVehiculo_parqueaderoId_fkey" FOREIGN KEY ("parqueaderoId") REFERENCES "Parqueadero"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VinculoVehiculo" ADD CONSTRAINT "VinculoVehiculo_afiliacionId_fkey" FOREIGN KEY ("afiliacionId") REFERENCES "Afiliacion"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VinculoVehiculo" ADD CONSTRAINT "VinculoVehiculo_vehiculoId_fkey" FOREIGN KEY ("vehiculoId") REFERENCES "Vehiculo"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CodigoVinculacion" ADD CONSTRAINT "CodigoVinculacion_parqueaderoId_fkey" FOREIGN KEY ("parqueaderoId") REFERENCES "Parqueadero"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CodigoVinculacion" ADD CONSTRAINT "CodigoVinculacion_afiliacionId_fkey" FOREIGN KEY ("afiliacionId") REFERENCES "Afiliacion"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CodigoQr" ADD CONSTRAINT "CodigoQr_parqueaderoId_fkey" FOREIGN KEY ("parqueaderoId") REFERENCES "Parqueadero"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CodigoQr" ADD CONSTRAINT "CodigoQr_vehiculoId_fkey" FOREIGN KEY ("vehiculoId") REFERENCES "Vehiculo"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Movimiento" ADD CONSTRAINT "Movimiento_parqueaderoId_fkey" FOREIGN KEY ("parqueaderoId") REFERENCES "Parqueadero"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Movimiento" ADD CONSTRAINT "Movimiento_celdaId_fkey" FOREIGN KEY ("celdaId") REFERENCES "Celda"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Movimiento" ADD CONSTRAINT "Movimiento_tarifaId_fkey" FOREIGN KEY ("tarifaId") REFERENCES "Tarifa"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Movimiento" ADD CONSTRAINT "Movimiento_vehiculoId_fkey" FOREIGN KEY ("vehiculoId") REFERENCES "Vehiculo"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Movimiento" ADD CONSTRAINT "Movimiento_registradoPorId_fkey" FOREIGN KEY ("registradoPorId") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Movimiento" ADD CONSTRAINT "Movimiento_dispositivoId_fkey" FOREIGN KEY ("dispositivoId") REFERENCES "Dispositivo"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Pago" ADD CONSTRAINT "Pago_parqueaderoId_fkey" FOREIGN KEY ("parqueaderoId") REFERENCES "Parqueadero"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Pago" ADD CONSTRAINT "Pago_afiliacionId_fkey" FOREIGN KEY ("afiliacionId") REFERENCES "Afiliacion"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Pago" ADD CONSTRAINT "Pago_tarifaId_fkey" FOREIGN KEY ("tarifaId") REFERENCES "Tarifa"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Dispositivo" ADD CONSTRAINT "Dispositivo_parqueaderoId_fkey" FOREIGN KEY ("parqueaderoId") REFERENCES "Parqueadero"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bitacora" ADD CONSTRAINT "Bitacora_parqueaderoId_fkey" FOREIGN KEY ("parqueaderoId") REFERENCES "Parqueadero"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bitacora" ADD CONSTRAINT "Bitacora_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "Usuario"("id") ON DELETE SET NULL ON UPDATE CASCADE;
