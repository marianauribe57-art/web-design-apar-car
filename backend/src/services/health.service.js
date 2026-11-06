import { verificarConexion } from '../repositories/health.repository.js';

export async function obtenerEstado() {
  try {
    await verificarConexion();
    return { status: 'ok', baseDeDatos: 'conectada' };
  } catch {
    return { status: 'ok', baseDeDatos: 'sin conexion' };
  }
}