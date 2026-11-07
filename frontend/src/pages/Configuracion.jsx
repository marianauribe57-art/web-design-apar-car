import { useEffect, useState } from 'react';
import { tarifa, formatoPesos } from '../datos/muestra';

const herramientas = [
  { nombre: 'GitHub Actions', uso: 'Lint y pruebas en cada push y PR' },
  { nombre: 'Vercel', uso: 'Despliegue continuo y vistas previas' },
  { nombre: 'Prisma ORM', uso: 'Modelo de datos y migraciones en PostgreSQL' },
];

function Configuracion() {
  const [estado, setEstado] = useState('Consultando...');
  const [enLinea, setEnLinea] = useState(null);

  useEffect(() => {
    fetch('/api/health')
      .then((respuesta) => {
        if (!respuesta.ok) throw new Error(`Error HTTP ${respuesta.status}`);
        return respuesta.json();
      })
      .then((datos) => {
        setEstado(datos.status);
        setEnLinea(true);
      })
      .catch(() => {
        setEstado('Sin conexión con el servidor');
        setEnLinea(false);
      });
  }, []);

  const colorEstado = enLinea === null ? 'secondary' : enLinea ? 'success' : 'danger';

  return (
    <div className="container">
      <h1 className="text-primary mb-4">Configuración</h1>

      <div className="row g-4">
        <div className="col-12 col-lg-6">
          <div className="card h-100">
            <div className="card-header fw-bold">Tarifa vigente</div>
            <ul className="list-group list-group-flush">
              <li className="list-group-item d-flex justify-content-between"><span>Hora</span><strong>{formatoPesos(tarifa.valorHora)}</strong></li>
              <li className="list-group-item d-flex justify-content-between"><span>Día</span><strong>{formatoPesos(tarifa.valorDia)}</strong></li>
              <li className="list-group-item d-flex justify-content-between"><span>Mensualidad</span><strong>{formatoPesos(tarifa.valorMensualidad)}</strong></li>
              <li className="list-group-item d-flex justify-content-between text-muted"><span>Vigente desde</span><span>{tarifa.vigenteDesde}</span></li>
            </ul>
          </div>
        </div>

        <div className="col-12 col-lg-6">
          <div className="card h-100">
            <div className="card-header fw-bold">Herramientas TIC</div>
            <div className="card-body">
              <p className="mb-3">
                Servidor (<code>/api/health</code>):{' '}
                <span className={`badge bg-${colorEstado}`}>{estado}</span>
              </p>
              <ul className="list-unstyled mb-0">
                {herramientas.map((h) => (
                  <li key={h.nombre} className="mb-2">
                    <strong>{h.nombre}</strong>
                    <br />
                    <small className="text-muted">{h.uso}</small>
                  </li>
                ))}
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Configuracion;