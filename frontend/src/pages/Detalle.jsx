import { Link, useParams } from 'react-router';
import { movimientos, tarifa, formatoHora, formatoPesos } from '../datos/muestra';

function Detalle() {
  const { id } = useParams();
  const movimiento = movimientos.find((m) => m.id === Number(id));

  if (!movimiento) {
    return (
      <div className="container">
        <p>No existe el movimiento #{id}.</p>
        <Link to="/panel">← Volver al panel</Link>
      </div>
    );
  }

  const fin = movimiento.salida ? new Date(movimiento.salida) : new Date();
  const minutos = Math.max(0, Math.round((fin - new Date(movimiento.entrada)) / 60000));
  const horasCobradas = Math.max(1, Math.ceil(minutos / 60));
  const valor = movimiento.valor ?? horasCobradas * tarifa.valorHora;
  const abierto = movimiento.salida === null;

  return (
    <div className="container">
      <Link to="/panel" className="d-inline-block mb-3">← Volver al panel</Link>
      <h1 className="text-primary mb-4">
        Movimiento #{movimiento.id}{' '}
        <span className={`badge fs-6 align-middle ${abierto ? 'bg-warning text-dark' : 'bg-secondary'}`}>
          {abierto ? 'Adentro' : 'Cerrado'}
        </span>
      </h1>

      <div className="card" style={{ maxWidth: '520px' }}>
        <ul className="list-group list-group-flush">
          <li className="list-group-item d-flex justify-content-between"><span>Placa</span><strong>{movimiento.placa}</strong></li>
          <li className="list-group-item d-flex justify-content-between"><span>Tipo</span><strong>{movimiento.tipoVehiculo}</strong></li>
          <li className="list-group-item d-flex justify-content-between"><span>Celda</span><strong>{movimiento.celda}</strong></li>
          <li className="list-group-item d-flex justify-content-between"><span>Entrada</span><strong>{formatoHora(movimiento.entrada)}</strong></li>
          <li className="list-group-item d-flex justify-content-between">
            <span>Salida</span><strong>{abierto ? 'Sigue adentro' : formatoHora(movimiento.salida)}</strong>
          </li>
          <li className="list-group-item d-flex justify-content-between">
            <span>Tiempo</span><strong>{Math.floor(minutos / 60)} h {minutos % 60} min</strong>
          </li>
          <li className="list-group-item d-flex justify-content-between bg-light">
            <span>{abierto ? 'Valor acumulado' : 'Valor cobrado'}</span>
            <strong className="text-success fs-5">{formatoPesos(valor)}</strong>
          </li>
        </ul>
      </div>
    </div>
  );
}

export default Detalle;