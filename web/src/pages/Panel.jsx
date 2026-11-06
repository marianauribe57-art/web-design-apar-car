import { Link } from 'react-router';
import { celdas, movimientos, formatoHora } from '../datos/muestra';

function Panel() {
  const ocupadas = celdas.filter((c) => c.estado === 'OCUPADA').length;
  const adentro = movimientos.filter((m) => m.salida === null);

  const tarjetas = [
    { titulo: 'Celdas totales', valor: celdas.length, color: 'primary' },
    { titulo: 'Ocupadas', valor: ocupadas, color: 'danger' },
    { titulo: 'Libres', valor: celdas.length - ocupadas, color: 'success' },
  ];

  return (
    <div className="container">
      <h1 className="text-primary mb-4">Panel de control</h1>

      <div className="row g-3 mb-4">
        {tarjetas.map((t) => (
          <div className="col-12 col-md-4" key={t.titulo}>
            <div className={`card border-${t.color}`}>
              <div className="card-body">
                <p className="text-muted mb-1">{t.titulo}</p>
                <p className={`fs-2 fw-bold text-${t.color} mb-0`}>{t.valor}</p>
              </div>
            </div>
          </div>
        ))}
      </div>

      <h2 className="h5">Ocupación de celdas</h2>
      <div className="d-flex flex-wrap gap-2 mb-4">
        {celdas.map((c) => (
          <span
            key={c.codigo}
            className={`badge fs-6 ${c.estado === 'OCUPADA' ? 'bg-danger' : 'bg-success'}`}
          >
            {c.codigo} · {c.tipo}
          </span>
        ))}
      </div>

      <h2 className="h5">Vehículos adentro</h2>
      <table className="table table-hover">
        <thead>
          <tr>
            <th>Placa</th>
            <th>Tipo</th>
            <th>Celda</th>
            <th>Entrada</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {adentro.map((m) => (
            <tr key={m.id}>
              <td className="fw-bold">{m.placa}</td>
              <td>{m.tipoVehiculo}</td>
              <td>{m.celda}</td>
              <td>{formatoHora(m.entrada)}</td>
              <td>
                <Link to={`/movimientos/${m.id}`} className="btn btn-sm btn-outline-primary">
                  Ver detalle
                </Link>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export default Panel;