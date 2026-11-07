// Datos de muestra: el esqueleto no tiene lógica de negocio todavía.
export const celdas = [
  { codigo: 'C-01', tipo: 'CARRO', estado: 'OCUPADA' },
  { codigo: 'C-02', tipo: 'CARRO', estado: 'LIBRE' },
  { codigo: 'C-03', tipo: 'CARRO', estado: 'OCUPADA' },
  { codigo: 'M-01', tipo: 'MOTO', estado: 'OCUPADA' },
  { codigo: 'M-02', tipo: 'MOTO', estado: 'LIBRE' },
  { codigo: 'X-01', tipo: 'MIXTA', estado: 'LIBRE' },
];

export const movimientos = [
  { id: 1, placa: 'ABC123', tipoVehiculo: 'CARRO', celda: 'C-01', entrada: '2026-11-06T08:15:00-05:00', salida: null, valor: null },
  { id: 2, placa: 'XYZ98F', tipoVehiculo: 'MOTO', celda: 'M-01', entrada: '2026-11-06T09:40:00-05:00', salida: null, valor: null },
  { id: 3, placa: 'JKL456', tipoVehiculo: 'CARRO', celda: 'C-03', entrada: '2026-11-06T10:05:00-05:00', salida: null, valor: null },
  { id: 4, placa: 'QWE789', tipoVehiculo: 'CARRO', celda: 'C-02', entrada: '2026-11-06T06:30:00-05:00', salida: '2026-11-06T09:00:00-05:00', valor: 9000 },
];

export const tarifa = {
  valorHora: 3000,
  valorDia: 20000,
  valorMensualidad: 180000,
  vigenteDesde: '2026-11-01',
};

export const formatoHora = (iso) =>
  new Date(iso).toLocaleTimeString('es-CO', { hour: '2-digit', minute: '2-digit', timeZone: 'America/Bogota' });

export const formatoPesos = (valor) =>
  valor.toLocaleString('es-CO', { style: 'currency', currency: 'COP', maximumFractionDigits: 0 });