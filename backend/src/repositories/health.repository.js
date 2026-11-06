import { prisma } from '../config/prisma.js';

export async function verificarConexion() {
  await prisma.$queryRaw`SELECT 1`;
}