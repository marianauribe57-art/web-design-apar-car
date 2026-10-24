import { obtenerEstado } from '../services/health.service.js';

export async function getHealth(req, res) {
  const estado = await obtenerEstado();
  res.json(estado);
}