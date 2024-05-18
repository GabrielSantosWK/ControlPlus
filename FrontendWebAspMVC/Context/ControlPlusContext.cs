using FrontendWebAspMVC.Models.Entities;
using Microsoft.EntityFrameworkCore;

namespace FrontendWebAspMVC.Context
{
    public class ControlPlusContext : DbContext
    {
        public ControlPlusContext(DbContextOptions options) : base(options) { }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Operacoes>().
               ToTable("lancamentos_operacaoes")
               .HasKey(x => x.Id);

            modelBuilder.Entity<Operacoes>()
           .Property(e => e.Id)
           .HasColumnName("id");

            modelBuilder.Entity<Operacoes>()
                .Property(e => e.Descricao)
                .HasColumnName("descricao")
                .HasColumnType("varchar(100)")
                .IsRequired();

            modelBuilder.Entity<Bancos>().
               ToTable("bancos")
               .HasKey(x => x.Id);

            modelBuilder.Entity<Bancos>()
           .Property(e => e.Id)
           .HasColumnName("id");

            modelBuilder.Entity<Bancos>()
                .Property(e => e.Descricao)
                .HasColumnName("descricao")
                .HasColumnType("varchar(100)")
                .IsRequired();

            modelBuilder.Entity<Dependentes>().
               ToTable("dependentes")
               .HasKey(x => x.Id);

            modelBuilder.Entity<Dependentes>()
           .Property(e => e.Id)
           .HasColumnName("id");

            modelBuilder.Entity<Dependentes>()
                .Property(e => e.Nome)
                .HasColumnName("nome")
                .HasColumnType("varchar(100)")
                .IsRequired();

            modelBuilder.Entity<Cartoes>().
               ToTable("cartoes")
               .HasKey(x => x.Id);

            modelBuilder.Entity<Cartoes>()
           .Property(e => e.Id)
           .HasColumnName("id");

            modelBuilder.Entity<Cartoes>()
                .Property(e => e.Descricao)
                .HasColumnName("descricao")
                .HasColumnType("varchar(100)")
                .IsRequired();

            modelBuilder.Entity<Cartoes>()
                .Property(e => e.BancoId)
                .HasColumnName("id_banco")
                .HasColumnType("varchar(100)")
                .IsRequired();

            modelBuilder.Entity<Cartoes>()
                .Property(e => e.DiaVencimento)
                .HasColumnName("dia_vencimento")
                .HasColumnType("int4")
                .IsRequired();

            modelBuilder.Entity<Cartoes>()
                .Property(e => e.Limite)
                .HasColumnName("limite")
                .HasColumnType("numeric(10,2)")
                .IsRequired();


            modelBuilder.Entity<Lancamento>().
               ToTable("lancamentos")
               .HasKey(x => x.Id);

            modelBuilder.Entity<Lancamento>()
           .Property(e => e.Id)
           .HasColumnName("id");

            modelBuilder.Entity<Lancamento>()
                .Property(e => e.Descricao)
                .HasColumnName("descricao")
                .HasColumnType("varchar(100)")
                .IsRequired();

            modelBuilder.Entity<Lancamento>()
                .Property(e => e.DependenteId)
                .HasColumnName("id_dependente")
                .HasColumnType("varchar(100)")
                .IsRequired();

            modelBuilder.Entity<Lancamento>()
                .Property(e => e.CartaoId)
                .HasColumnName("id_cartao")
                .HasColumnType("varchar(100)")
                .IsRequired();


            modelBuilder.Entity<Lancamento>()
                .Property(e => e.DataLancamento)
                .HasColumnName("data_lancamento")
                .HasColumnType("date")
                .IsRequired();

            modelBuilder.Entity<Lancamento>()
                .Property(e => e.DataVencimento)
                .HasColumnName("data_vencimento")
                .HasColumnType("date")
                .IsRequired();

            modelBuilder.Entity<Lancamento>()
                .Property(e => e.OperacaoId)
                .HasColumnName("id_operacao")
                .HasColumnType("varchar(100)")
                .IsRequired();

            modelBuilder.Entity<Lancamento>()
                .Property(e => e.Valor)
                .HasColumnName("valor")
                .HasColumnType("numeric(12,4)")
                .IsRequired();

            modelBuilder.Entity<Lancamento>()
                .Property(e => e.ContaCasal)
                .HasColumnName("conta_casal")
                .HasColumnType("bool")
                .IsRequired();
        }
        public DbSet<Lancamento> Lancamentos { get; set; }
        public DbSet<Cartoes> Cartoes { get; set; }
        public DbSet<Bancos> Bancos { get; set; }
       
        public DbSet<Operacoes> Operacoes { get; set; }
        public DbSet<Dependentes> Dependentes { get; set; }

    }
}
